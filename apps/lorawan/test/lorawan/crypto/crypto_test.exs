defmodule LoRaWAN.Crypto.CryptoTest do
  use ExUnit.Case, async: true
  alias LoRaWAN.Crypto.AesCmac


  test "test MIC" do
    nwsk = <<121, 91, 177, 245, 56, 223, 79, 142, 120, 116, 172, 170, 82, 95, 205, 204>>

    data = <<64, 208, 246, 125, 29, 0, 0, 0, 3, 172, 229, 114, 233, 126, 95>>
    IO.puts "Data #{inspect(data)}"
    <<mhdr::binary-size(1), rest::binary>> = data
    IO.puts "MHDR #{inspect(mhdr)}"
    mac_payload_len = byte_size(rest) - 4
    IO.puts "MAC Payload Length #{inspect(mac_payload_len)}"
    <<mac_payload::binary-size(mac_payload_len), mic::binary>> = rest
    IO.puts "MAC Payload #{inspect(mac_payload)}"
    IO.puts "MIC #{inspect(mic)}"

    <<dev_addr::binary-size(4), fctrl::binary-size(1), fcnt::little-unsigned-integer-size(16), rest::binary>> = mac_payload

    IO.puts "DevAddr #{inspect(String.reverse(dev_addr))}"
    IO.puts "FCtrl #{inspect(fctrl)}"
    IO.puts "FCnt #{inspect(fcnt)}"

    <<adr::1, adr_ack_req::1, ack::1, rfu::1, fopts_len::integer-size(4)>> = fctrl

    IO.puts "ADR #{inspect(adr)}"
    IO.puts "ADR_ACK_Req #{inspect(adr_ack_req)}"
    IO.puts "ACK #{inspect(ack)}"
    IO.puts "RFU #{inspect(rfu)}"
    IO.puts "FOptsLen #{inspect(fopts_len)}"

    {fopts, fport, frm_payload} = case fopts_len do
      0 ->
        <<fport::binary-size(1), frm_payload::binary>> = rest
        {0, fport, frm_payload}
      _ -> {0, 0, 0}
    end
    IO.puts "FPort #{inspect(fport)}"
    IO.puts "FRMPayload #{inspect(frm_payload)}"

    fhdr = IO.iodata_to_binary([dev_addr, fctrl, fcnt, fopts])
    IO.puts "FHDR #{inspect(fhdr)}"

    msg = IO.iodata_to_binary [mhdr, fhdr, fport, frm_payload]
    b0 = IO.iodata_to_binary [0x49, 0, 0, 0, 0, 0, dev_addr, <<fcnt::little-unsigned-integer-size(32)>>, 0, <<byte_size(msg)::8>>]

    IO.puts("MSG #{inspect(msg)}")
    IO.puts("B0 #{inspect(b0)}")

    cmac = AesCmac.aes_cmac(nwsk, IO.iodata_to_binary [b0, msg])
    <<computed_mic::binary-size(4), _::binary>> = cmac

    IO.puts("CMAC #{inspect(cmac)}")
    IO.puts("Computed MIC #{inspect(computed_mic)}")
    IO.puts("MIC #{inspect(mic)}")

    assert computed_mic == mic
  end
end
