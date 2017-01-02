defmodule LoRaWAN.Crypto.CryptoTest do
  use ExUnit.Case, async: true
  alias LoRaWAN.Crypto.AesCmac


  defp check_mic(nwk_s_key, raw) do
    packet = LoRaWAN.Decoder.decode(raw)

    mhdr_raw = packet.mhdr.raw
    mic_raw = packet.mic
    fhdr_raw = packet.mac_payload.fhdr.raw

    fhdr = packet.mac_payload.fhdr
    f_port = packet.mac_payload.f_port
    frm_payload = packet.mac_payload.frm_payload

    msg = IO.iodata_to_binary [mhdr_raw, fhdr_raw, f_port, frm_payload]

    b0 = IO.iodata_to_binary [0x49, 0, 0, 0, 0, 0, fhdr.dev_addr, <<fhdr.f_cnt::little-unsigned-integer-size(32)>>, 0, <<byte_size(msg)::8>>]
    data = b0 <> msg

    cmac = AesCmac.aes_cmac(nwk_s_key, data)
    computed_mic = :erlang.binary_part(cmac, 0, 4)

    assert computed_mic == mic_raw
  end

  test "test Data MIC #1" do
    nwk_s_key = <<121, 91, 177, 245, 56, 223, 79, 142, 120, 116, 172, 170, 82, 95, 205, 204>>
    raw = <<64, 208, 246, 125, 29, 0, 0, 0, 3, 172, 229, 114, 233, 126, 95>>

    check_mic(nwk_s_key, raw)
  end

  test "test Data MIC #2" do
    nwk_s_key = <<1, 185, 164, 190, 233, 251, 174, 124, 20, 205, 59, 189, 253, 69, 128, 224>>
    raw = <<64, 71, 28, 1, 38, 0, 184, 0, 3, 22, 125, 201, 92, 186, 50, 198>>

    check_mic(nwk_s_key, raw)
  end

  test "test Data MIC #3" do
    nwk_s_key = <<1, 185, 164, 190, 233, 251, 174, 124, 20, 205, 59, 189, 253, 69, 128, 224>>
    raw = <<64, 71, 28, 1, 38, 0, 24, 0, 3, 127, 186, 242, 252, 121, 80, 227>>

    check_mic(nwk_s_key, raw)
  end

  test "test Data MIC #4" do
    nwk_s_key = <<1, 185, 164, 190, 233, 251, 174, 124, 20, 205, 59, 189, 253, 69, 128, 224>>
    raw = <<64, 71, 28, 1, 38, 0, 186, 2, 3, 220, 119, 90, 228, 71, 201, 122>>

    check_mic(nwk_s_key, raw)
  end
end
