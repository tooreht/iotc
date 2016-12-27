defmodule LoRaWAN.Crypto do
  @moduledoc """
  This module is responsible for the crypto part of LoRaWAN.
  """
  alias LoRaWAN.Crypto.AesCmac
  alias Core.Storage
  alias Core.Storage.Utils
  require Logger

  @doc """
  Calculate and validate the MIC (Message Integrity Code).

  ## MIC

  The message integrity code (MIC) is calculated over all the fields in the message.

      msg = MHDR | FHDR | FPort | FRMPayload

  whereby len(msg) denotes the length of the message in octets.
  
  The MIC is calculated as follows [RFC4493]:

      cmac = aes128_cmac(NwkSKey, B0 | msg)
      MIC = cmac[0..3]

  whereby the block B0 is defined as follows: Size (bytes)

                    -------------------------------------------------------------------------------
       Size (bytes) |     1    |    4     |    1     |    4     |    4      |    1     |    1     |
      --------------|----------|----------|----------|----------|-----------|----------|-----------
                 B0 |   0x49   | 4 x 0x00 |    Dir   | DevAddr  | FCntUp or |   0x00   | len(msg) |
                    |          |          |          |          | FCntDown  |          |          |
                    |          |          |          |          |           |          |          |
                    -------------------------------------------------------------------------------

  The direction field (Dir) is 0 for uplink packets and 1 for downlink packets.
  """
  def valid_mic(packet) do
    case packet.mhdr.m_type do
      0x00 -> # Join Request
        app_eui = packet.mac_payload.app_eui
        dev_eui = packet.mac_payload.dev_eui
        dev_nonce = packet.mac_payload.dev_nonce

        app_key = get_app_key(app_eui, dev_eui)

        mhdr_raw = packet.mhdr.raw
        mic_raw = packet.mic

        msg = mhdr_raw <> app_eui <> dev_eui <> dev_nonce
        cmac = AesCmac.aes_cmac(app_key, msg)
        <<computed_mic::binary-size(4), _::binary>> = cmac

        {computed_mic == mic_raw, packet}
      n when n in [0x02, 0x04] -> # Unconfirmed Data Up
        mhdr_raw = packet.mhdr.raw
        mic_raw = packet.mic
        fhdr_raw = packet.mac_payload.fhdr.raw

        fhdr = packet.mac_payload.fhdr
        f_port = packet.mac_payload.f_port
        frm_payload = packet.mac_payload.frm_payload

        msg = IO.iodata_to_binary [mhdr_raw, fhdr_raw, f_port, frm_payload]
        b0 = IO.iodata_to_binary [0x49, 0, 0, 0, 0, 0, fhdr.dev_addr, <<fhdr.f_cnt::little-unsigned-integer-size(32)>>, 0, <<byte_size(msg)::8>>]
        data = IO.iodata_to_binary [b0, msg]

        nodes = get_nodes(fhdr.dev_addr, fhdr.f_cnt)

        try_mic(nodes, data, mic_raw)
      _ ->
        Logger.warn "no valid m_type"
        {false, nil}
    end
  end

  defp get_nodes(rev_dev_addr, f_cnt) do
    dev_addr = Utils.rev_bytes_to_base16(rev_dev_addr)
    nodes = Storage.LoRaWAN.Node.get_nodes(%{dev_addr: dev_addr, f_cnt: f_cnt})
    if nodes == [] do
      Logger.warn "no device with dev_addr " <> inspect(dev_addr) <> " found!"
      nodes
    else
      nodes
    end
  end

  def try_mic([node | tail], data, mic) do
    cmac = AesCmac.aes_cmac(Utils.rev_bytes_from_base16(node.nwk_s_key), data)
    <<computed_mic::binary-size(4), _::binary>> = cmac
    if computed_mic == mic do
      {true, node}
    else
      try_mic(tail, data, mic)
    end
  end

  def try_mic([], data, mic) do
    {false, nil}
  end

  defp get_app_key(app_eui, dev_eui) do
    # TODO: lookup app_eui in DB and get app_key
    case {app_eui, dev_eui} do
      {<<54, 14, 0, 208, 126, 213, 179, 112>>, <<139, 119, 102, 95, 78, 61, 43, 42>>} ->
        <<191, 185, 219, 229, 78, 139, 209, 131, 24, 59, 112, 168, 106, 103, 175, 73>>
      _ ->
        Logger.warn "No combination of AppEUI + DevEUI found -> no AppKey Found!"
        <<0x00000000000000000000000000000000::128>>
    end
  end

end
