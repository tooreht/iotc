defmodule LoRaWAN.Crypto do
  @moduledoc """
  This module is responsible for the crypto part of LoRaWAN.
  """
  alias LoRaWAN.Crypto.AesCmac
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

        {nws_key, dev_eui} = get_nws_key(fhdr.dev_addr)

        cmac = AesCmac.aes_cmac(nws_key, IO.iodata_to_binary [b0, msg])
        <<computed_mic::binary-size(4), _::binary>> = cmac

        mic_check = computed_mic == mic_raw

        node = if mic_check do
          # packet = putpacket.node.dev_eui = dev_eui
          # packet = Map.put(%LoRaWAN.Packet.Node{}, :dev_eui, <<0>>)
         node
        end

        {mic_check, node}
      _ ->
        Logger.warn "no valid m_type"
        {false, nil}
    end
  end

  defp get_nws_key(dev_addr) do
    # TODO: lookup dev_addr in DB and get nws_key
    case dev_addr do
      <<121, 210, 161, 70>> ->
        {<<131, 132, 1, 172,  17, 228, 225, 223, 76, 106, 213, 106, 7,  71, 210, 196>>, <<0>>}
      <<208, 246, 125, 29>> ->
        {<<121, 91, 177, 245, 56, 223, 79, 142, 120, 116, 172, 170, 82, 95, 205, 204>>, <<0>>}
      <<70, 161, 210, 121>> ->
        {<<131, 132, 1, 172, 17, 228, 225, 223, 76, 106, 213, 106, 7, 71, 210, 196>>, <<0>>}
      _ ->
        Logger.warn "No NwkSKey found!"
        {<<0x00000000000000000000000000000000::128>>, <<0>>}
    end
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
