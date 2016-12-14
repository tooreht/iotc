defmodule LoRaWAN.Decoder do
  @moduledoc """
  This module is responsible for the decoding of the different packet types.
  """

  alias LoRaWAN.Packet
  require Integer
  require Logger

  @doc """
  Decodes LoRaWAN frames into the structures acording to packet.ex
  
  """
  def decode(phy_payload) do
    <<raw_mhdr::binary-size(1), rest::binary>> = phy_payload
    <<m_type::3 , rfu::3 , major::2>> = raw_mhdr

    mac_payload_len = byte_size(rest) - 4
    <<raw_mac_payload::binary-size(mac_payload_len), mic::binary>> = rest


    mac_payload = case m_type do
      n when n in [0, 1] ->
        decode_join_mac(raw_mac_payload)
      n when n in [2, 3, 4, 5] ->
        decode_data_mac(raw_mac_payload, m_type)
      6 ->
        decode_proprietary_mac(raw_mac_payload)
      _ ->
        Logger.warn "Received Packet with MType not defined -> Drop"
    end

    mhdr = %Packet.MHDR{
      m_type: m_type,
      rfu:    rfu,
      major:  major,
      raw:    raw_mhdr
    }

    packet = %Packet.PHYPayload{
      mhdr: mhdr,
      mac_payload: mac_payload,
      mic: mic,
      raw: phy_payload
    }
  end

  def msg_direction(m_type) do
    if Integer.is_even(m_type), do: :uplink, else: :downlink
  end

  def decode_join_mac(raw_mac_payload) do
    Logger.info "this is a Join Message"
    <<app_eui::binary-size(8), dev_eui::binary-size(8), dev_nonce::binary-size(2)>> = raw_mac_payload

    mac_payload = %Packet.JoinMACPayload{
      app_eui:    app_eui,
      dev_eui:    dev_eui,
      dev_nonce:  dev_nonce,
      raw:        raw_mac_payload  
    }
  end

  def decode_data_mac(raw_mac_payload, m_type) do
    Logger.info "this is a Data Message"
    <<dev_addr::binary-size(4), raw_f_ctrl::binary-size(1), f_cnt::little-unsigned-integer-size(16), rest::binary>> = raw_mac_payload
    <<adr::1, adr_ack_req::1, ack::1, rfu_or_f_pending::1, f_opts_len::integer-size(4)>> = raw_f_ctrl

    {f_opts, f_port, frm_payload} = case f_opts_len do
      0 ->
        <<f_port::binary-size(1), frm_payload::binary>> = rest
        {<<0::0>>, f_port, frm_payload}
      _ -> {0, 0, 0} # TODO IMPLEMENT CORRECT reading of FOpts!
    end

    # fhdr = IO.iodata_to_binary([dev_addr, f_ctrl, <<f_cnt::little-unsigned-integer-size(16)>>, f_opts])
    #raw_fhdr = IO.iodata_to_binary([dev_addr, raw_f_ctrl, f_cnt, f_opts])
    raw_fhdr = dev_addr <> raw_f_ctrl <> <<f_cnt::little-unsigned-integer-size(16)>> <> f_opts


    {key, value} = case msg_direction(m_type) do
      :uplink -> {:rfu, rfu_or_f_pending}
      :downlink -> {:f_pending, rfu_or_f_pending}
    end

    f_ctrl = Map.put(%Packet.FCtrl{
      adr: adr,
      adr_ack_req: adr_ack_req,
      ack: ack,
      f_opts_len: f_opts_len,
      raw: raw_f_ctrl
    }, key, value) 

    fhdr = %Packet.FHDR{
      dev_addr: dev_addr,
      f_ctrl: f_ctrl,
      f_cnt: f_cnt,
      f_opts: f_opts,
      raw: raw_fhdr
    }

    mac_payload = %Packet.DataMACPayload{
      fhdr: fhdr,
      f_port: f_port,
      frm_payload: frm_payload,
      raw: raw_mac_payload
    }
  end

  def decode_proprietary_mac(raw_mac_payload) do
    # TODO Implement!
    IO.puts "Decode Proprietary MAC is NOT IMPLEMENTED"
    <<0>>
  end

end
