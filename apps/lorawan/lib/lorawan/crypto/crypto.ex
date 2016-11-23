defmodule LoRaWAN.Crypto do
  @moduledoc """
  This module is responsible for the crypto part of LoRaWAN.
  """
  alias LoRaWAN.Crypto.AesCmac
  alias LoRaWAN.Frame


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

  The direction field (Dir) is 0 for uplink frames and 1 for downlink frames.
  """
  def valid_mic?(frame) do
    case frame.phy_payload.mhdr.m_type do
      0x00 -> # Join Request
        # MIC Check by APP KEY
        false
      0x02 -> # Unconfirmed Data Up
        %Frame.Raw{phy_payload: _, mhdr: mhdr_raw, mac_payload: _, mic: mic_raw, fhdr: fhdr_raw, f_ctrl: _} = frame.raw

        fhdr = frame.phy_payload.mac_payload.fhdr
        f_port = frame.phy_payload.mac_payload.f_port
        frm_payload = frame.phy_payload.mac_payload.frm_payload

        msg = IO.iodata_to_binary [mhdr_raw, fhdr_raw, f_port, frm_payload]
        b0 = IO.iodata_to_binary [0x49, 0, 0, 0, 0, 0, fhdr.dev_addr, <<fhdr.f_cnt::little-unsigned-integer-size(32)>>, 0, <<byte_size(msg)::8>>]
        IO.puts("DevAddr #{inspect(fhdr.dev_addr)}")
        nws_key = get_nws_key(fhdr.dev_addr)        

        IO.puts("NWS Key #{inspect(nws_key)}")
        IO.puts("MSG #{inspect(msg)}")
        IO.puts("B0 #{inspect(b0)}")

        cmac = AesCmac.aes_cmac(nws_key, IO.iodata_to_binary [b0, msg])
        <<computed_mic::binary-size(4), _::binary>> = cmac

        IO.puts("CMAC #{inspect(cmac)}")
        IO.puts("Computed MIC #{inspect(computed_mic)}")
        IO.puts("MIC #{inspect(mic_raw)}")

        computed_mic == mic_raw
      0x04 -> # Confirmed Data Up
        nws_key = get_nws_key(frame.phy_payload.mac_payload.fhdr.dev_addr)
        IO.puts(inspect nws_key)
        false
      _ ->
        false
    end
  end

  defp get_nws_key(dev_addr) do
    # TODO: lookup dev_addr in DB and get nws_key
    case dev_addr do
      <<121, 210, 161, 70>> ->
        <<131, 132, 1, 172,  17, 228, 225, 223, 76, 106, 213, 106, 7,  71, 210, 196>>
      <<208, 246, 125, 29>> ->
        <<121, 91, 177, 245, 56, 223, 79, 142, 120, 116, 172, 170, 82, 95, 205, 204>>
      _ ->
        <<0x00000000000000000000000000000000::128>>
    end
  end

  defp get_app_key(app_eui, dev_eui) do
    # TODO: lookup app_eui in DB and get app_key
    #case app_eui, dev_eui do
    #end
  end

end
