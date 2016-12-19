defmodule LoRaWAN.DecoderTest do
  use ExUnit.Case, async: true
  alias LoRaWAN.Packet

  test "It should extract an Data Message." do
    # Origin Base64 Message:  QOvHuxwAAAADifcrgYr0
    # HEX:                    0x40 0xEB 0xC7 0xBB 0x1C 0x00 0x00 0x00 0x03 0x89 0xF7 0x2B 0x81 0x8A 0xF4
    # Binary:                 <<64, 235, 199, 187, 28, 0, 0, 0, 3, 137, 247, 43, 129, 138, 244>>
    phy_payload =  <<64, 235, 199, 187, 28, 0, 0, 0, 3, 137, 247, 43, 129, 138, 244>>

    fCtrl = Map.put(%Packet.FCtrl{
                  adr: 0,
                  adr_ack_req: 0,
                  ack: 0,
                  f_opts_len: 0,
                  raw: <<0>>
                }, :rfu, 0) 

    packet = LoRaWAN.Decoder.decode phy_payload

    assert packet == %Packet.PHYPayload{
      mhdr: %Packet.MHDR{
        m_type: 0x02,
        rfu: 0,
        major: 0,
        raw: <<64>>
      },
      mac_payload: %Packet.DataMACPayload{
        fhdr: %Packet.FHDR{
            dev_addr: <<235, 199, 187, 28>>,
            f_ctrl: fCtrl,
            f_cnt: 0,
            f_opts: <<0::0>>,
            raw: <<235, 199, 187, 28, 0, 0, 0>>
          },
        f_port: <<3>>,
        frm_payload: <<137, 247>>,
        raw: <<235, 199, 187, 28, 0, 0, 0, 3, 137, 247>>
      },
      mic: <<43, 129, 138, 244>>,
      raw: phy_payload
    }
  end

  test "It should extract an Join Message." do
    # Origin Base64 Message: ADYOANB+1bNwi3dmX049Kyo9EiNeX3o=
    # HEX:                   0x00 0x36 0x0E 0x00 0xD0 0x7E 0xD5 0xB3 0x70 0x8B 0x77 0x66 0x5F 0x4E 0x3D 0x2B 0x2A 0x3D 0x12 0x23 0x5E 0x5F 0x7A
    # Binary:                <<0, 54, 14, 0, 208, 126, 213, 179, 112, 139, 119, 102, 95, 78, 61, 43, 42, 61, 18, 35, 94, 95, 122>>

    phy_payload = <<0, 54, 14, 0, 208, 126, 213, 179, 112, 139, 119, 102, 95, 78, 61, 43, 42, 61, 18, 35, 94, 95, 122>>

    packet = LoRaWAN.Decoder.decode phy_payload


    assert packet.mhdr.m_type == 0
    assert packet.mhdr.major == 0
    assert packet.mhdr.raw == <<0>>
    assert packet.mhdr.rfu == 0

    assert packet.mac_payload.app_eui == <<54, 14, 0, 208, 126, 213, 179, 112>>
    assert packet.mac_payload.dev_eui == <<139, 119, 102, 95, 78, 61, 43, 42>>
    assert packet.mac_payload.dev_nonce == <<61, 18>>
    assert packet.mac_payload.raw == <<54, 14, 0, 208, 126, 213, 179, 112, 139, 119, 102, 95, 78, 61, 43, 42, 61, 18>>

    assert packet.mic == "#^_z"
  end

  test "It should extract a Data Message (new)." do
    phy_payload = <<64, 208, 246, 125, 29, 0, 0, 0, 5, 172, 229, 114, 233, 126, 95>>
    packet = LoRaWAN.Decoder.decode phy_payload

    assert packet.mhdr.m_type == 2
    assert packet.mhdr.major == 0
    assert packet.mhdr.raw == <<64>>
    assert packet.mhdr.rfu == 0

    assert packet.mac_payload.fhdr.dev_addr == <<208, 246, 125, 29>>
    assert packet.mac_payload.fhdr.f_ctrl.adr == 0
    assert packet.mac_payload.fhdr.f_ctrl.adr_ack_req == 0
    assert packet.mac_payload.fhdr.f_ctrl.ack == 0
    assert packet.mac_payload.fhdr.f_ctrl.f_opts_len == 0
    assert packet.mac_payload.fhdr.f_ctrl.raw == <<0>>
    assert packet.mac_payload.fhdr.f_cnt == 0
    assert packet.mac_payload.fhdr.f_opts == <<0::0>>
    assert packet.mac_payload.fhdr.raw == <<208, 246, 125, 29, 0, 0, 0>>

    assert packet.mac_payload.f_port == <<5>>
    assert packet.mac_payload.frm_payload == <<172, 229>>
    assert packet.mac_payload.raw == <<208, 246, 125, 29, 0, 0, 0, 5, 172, 229>>

    assert packet.mic == <<114, 233, 126, 95>>
    assert packet.raw == <<64, 208, 246, 125, 29, 0, 0, 0, 5, 172, 229, 114, 233, 126, 95>>
  end

  test "It should extract a Data Message" do
    phy_payload = <<64, 221, 83, 103, 169, 130, 138, 6, 3, 7, 20, 44, 180, 122, 249, 213, 75, 180, 131, 118, 203, 232, 90, 191, 46>>
    packet = LoRaWAN.Decoder.decode phy_payload

    assert packet.mhdr.m_type == 2
    assert packet.mhdr.major == 0
    assert packet.mhdr.raw == <<64>>
    assert packet.mhdr.rfu == 0

    assert packet.mac_payload.fhdr.dev_addr == <<221, 83, 103, 169>>
    assert packet.mac_payload.fhdr.f_ctrl.adr == 1
    assert packet.mac_payload.fhdr.f_ctrl.adr_ack_req == 0
    assert packet.mac_payload.fhdr.f_ctrl.ack == 0
    assert packet.mac_payload.fhdr.f_ctrl.f_opts_len == 2
    assert packet.mac_payload.fhdr.f_ctrl.raw == <<130>>
    assert packet.mac_payload.fhdr.f_cnt == 1674
    assert packet.mac_payload.fhdr.f_opts == <<3, 7>>
    assert packet.mac_payload.fhdr.raw == <<221, 83, 103, 169, 130, 138, 6, 3, 7>>

    assert packet.mac_payload.f_port == <<20>>
    assert packet.mac_payload.frm_payload == <<44, 180, 122, 249, 213, 75, 180, 131, 118, 203>>
    assert packet.mac_payload.raw == <<221, 83, 103, 169, 130, 138, 6, 3, 7, 20, 44, 180, 122, 249, 213, 75, 180, 131, 118, 203>>

    assert packet.mic == <<232, 90, 191, 46>>
    assert packet.raw == <<64, 221, 83, 103, 169, 130, 138, 6, 3, 7, 20, 44, 180, 122, 249, 213, 75, 180, 131, 118, 203, 232, 90, 191, 46>>


  end
end
