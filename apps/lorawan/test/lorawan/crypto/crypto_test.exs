defmodule LoRaWAN.Crypto.CryptoTest do
  use ExUnit.Case, async: true
  alias LoRaWAN.Crypto.AesCmac


  test "test Data MIC" do
    nwsk = <<121, 91, 177, 245, 56, 223, 79, 142, 120, 116, 172, 170, 82, 95, 205, 204>>

    data = <<64, 208, 246, 125, 29, 0, 0, 0, 3, 172, 229, 114, 233, 126, 95>>

    <<mhdr::binary-size(1), rest::binary>> = data

    mac_payload_len = byte_size(rest) - 4

    <<mac_payload::binary-size(mac_payload_len), mic::binary>> = rest


    <<dev_addr::binary-size(4), fctrl::binary-size(1), fcnt::little-unsigned-integer-size(16), rest::binary>> = mac_payload

    <<_::4, fopts_len::integer-size(4)>> = fctrl



    {fopts, fport, frm_payload} = case fopts_len do
      0 ->
        <<fport::binary-size(1), frm_payload::binary>> = rest
        {0, fport, frm_payload}
      _ -> {0, 0, 0}
    end

    fhdr = IO.iodata_to_binary([dev_addr, fctrl, fcnt, fopts])

    msg = IO.iodata_to_binary [mhdr, fhdr, fport, frm_payload]
    b0 = IO.iodata_to_binary [0x49, 0, 0, 0, 0, 0, dev_addr, <<fcnt::little-unsigned-integer-size(32)>>, 0, <<byte_size(msg)::8>>]

    cmac = AesCmac.aes_cmac(nwsk, IO.iodata_to_binary [b0, msg])
    <<computed_mic::binary-size(4), _::binary>> = cmac

    assert computed_mic == mic
  end
end
