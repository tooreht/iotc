defmodule LoRaWAN.Decoder do
  @moduledoc """
  This module is responsible for the decoding of the different packet types.
  """

  alias LoRaWAN.Frame
  require Integer

  @doc """
  Decodes LoRaWAN frames into the following structures.

  ## Radio PHY layer

  At this point only the PHYPayload is left, because the rest is all radio specific.

      -------------------------------------------------
      | Preamble | PHDR | PHDR_CRC | PHYPayload | CRC |
      -------------------------------------------------

  ## PHYPayload

      ---------------------------
      | MHDR | MACPayload | MIC |
      ---------------------------

  ## MACPayload

      -----------------------------
      | FHDR | FPort | FRMPayload |
      -----------------------------
  
  """
  def decode(phy_payload) do
    <<mhdr::binary-size(1), rest::binary>> = phy_payload
    IO.puts "MHDR #{inspect(mhdr)}"
    <<m_type::3 , rfu::3 , major::2>> = mhdr
    IO.puts "MType #{inspect(m_type)}"
    IO.puts "RFU #{inspect(rfu)}"
    IO.puts "Major #{inspect(major)}"
    mac_payload_len = byte_size(rest) - 4
    IO.puts "MAC Payload Length #{inspect(mac_payload_len)}"
    <<mac_payload::binary-size(mac_payload_len), mic::binary>> = rest
    IO.puts "MAC Payload #{inspect(mac_payload)}"
    IO.puts "MIC #{inspect(mic)}"

    <<dev_addr::binary-size(4), f_ctrl::binary-size(1), f_cnt::little-unsigned-integer-size(16), rest::binary>> = mac_payload

    IO.puts "DevAddr #{inspect(String.reverse(dev_addr))}"
    IO.puts "FCtrl #{inspect(f_ctrl)}"
    IO.puts "FCnt #{inspect(f_cnt)}"

    <<adr::1, adr_ack_req::1, ack::1, rfu_or_f_pending::1, f_opts_len::integer-size(4)>> = f_ctrl

    IO.puts "ADR #{inspect(adr)}"
    IO.puts "ADR_ACK_Req #{inspect(adr_ack_req)}"
    IO.puts "ACK #{inspect(ack)}"
    IO.puts "RFU #{inspect(rfu)}"
    IO.puts "FOptsLen #{inspect(f_opts_len)}"

    {f_opts, f_port, frm_payload} = case f_opts_len do
      0 ->
        <<f_port::binary-size(1), frm_payload::binary>> = rest
        {0, f_port, frm_payload}
      _ -> {0, 0, 0}
    end
    IO.puts "FPort #{inspect(f_port)}"
    IO.puts "FRMPayload #{inspect(frm_payload)}"

    # fhdr = IO.iodata_to_binary([dev_addr, f_ctrl, <<f_cnt::little-unsigned-integer-size(16)>>, f_opts])
    fhdr = IO.iodata_to_binary([dev_addr, f_ctrl, f_cnt, f_opts])
    IO.puts "FHDR #{inspect(fhdr)}"

    raw = %Frame.Raw{
      phy_payload: phy_payload,
      mhdr: mhdr,
      mac_payload: mac_payload,
      mic: mic,
      fhdr: fhdr,
      f_ctrl: f_ctrl
    }

    {key, value} = case msg_direction(m_type) do
      :uplink -> {:rfu, rfu_or_f_pending}
      :downlink -> {:f_pending, rfu_or_f_pending}
    end

    IO.puts "RFU/FPending #{inspect(key)} => #{value}"

    f_ctrl = Map.put(%Frame.FCtrl{
      adr: adr,
      adr_ack_req: adr_ack_req,
      ack: ack,
      f_opts_len: f_opts_len,
    }, key, value) 

    fhdr = %Frame.FHDR{
      dev_addr: dev_addr,
      f_ctrl: f_ctrl,
      f_cnt: f_cnt,
      f_opts: f_opts,
    }

    mac_payload = %Frame.MACPayload{
      fhdr: fhdr,
      f_port: f_port,
      frm_payload: frm_payload,
    }

    mhdr = %Frame.MHDR{
      m_type: m_type,
      rfu: rfu,
      major: major,
    }

    phy_payload = %Frame.PHYPayload{
      mhdr: mhdr,
      mac_payload: mac_payload,
      mic: mic
    }

    %Frame{
      phy_payload: phy_payload,
      raw: raw
    }
  end

  def msg_direction(m_type) do
    IO.puts IO.inspect(m_type)
    if Integer.is_even(m_type), do: :uplink, else: :downlink
  end
end
