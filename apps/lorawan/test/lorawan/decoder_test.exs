defmodule LoRaWAN.DecoderTest do
  use ExUnit.Case, async: true
  alias LoRaWAN.Frame

  # Origin Base64 Message:  QOvHuxwAAAADifcrgYr0
  # HEX:                    0x40 0xEB 0xC7 0xBB 0x1C 0x00 0x00 0x00 0x03 0x89 0xF7 0x2B 0x81 0x8A 0xF4
  # Binary:                 <<64, 235, 199, 187, 28, 0, 0, 0, 3, 137, 247, 43, 129, 138, 244>>

  @phy_payload <<64, 235, 199, 187, 28, 0, 0, 0, 3, 137, 247, 43, 129, 138, 244>>

  # MHDR
  @mhdr <<2, 0, 0>>

  @m_type 0x02
  @rfu 0
  @major 0


  # MACPayload
  @mac_payload <<137, 247>>
  # @dev_addr <<28, 187, 199, 235>>
  @dev_addr <<235, 199, 187, 28>>
  @f_ctrl <<0>>
  @f_cnt 0
  @f_opts 0
  @f_port <<3>>
  @frm_payload <<137, 247>>

  # MIC
  @mic <<43, 129, 138, 244>>

  # FHDR
  @fhdr <<0, 0, 0, 0, 0, 0, 0>>

  # FCtrl
  @adr 0
  @adr_ack_req 0
  @ack 0
  @rfu 0
  @f_opts_len 0

  test "It should extract an UnconfirmedDataUp packet." do
    packet = LoRaWAN.Decoder.decode @phy_payload
    IO.puts inspect(packet)

    assert packet == %Frame{
      phy_payload: %Frame.PHYPayload{
        mhdr: %Frame.MHDR{
          m_type: @m_type,
          rfu: @rfu,
          major: @major
        },
        mac_payload: %Frame.MACPayload{
          fhdr: %Frame.FHDR{
              dev_addr: @dev_addr,
              f_ctrl: %Frame.FCtrl{
                adr: @adr,
                adr_ack_req: @adr_ack_req,
                ack: @ack,
                rfu: @rfu,
                f_opts_len: @f_opts_len
              },
              f_cnt: @f_cnt,
              f_opts: @f_opts
            },
          f_port: @f_port,
          frm_payload: @frm_payload
        },
        mic: @mic
      },
      raw: %Frame.Raw{
        phy_payload: @phy_payload,
        mhdr: @mhdr,
        mac_payload: @mac_payload,
        mic: @mic,
        fhdr: @fhdr,
        f_ctrl: @f_ctrl
      }
    }
  end

  # Origin Base64 Message: ADYOANB+1bNwi3dmX049Kyo9EiNeX3o=
  # HEX:                   0x00 0x36 0x0E 0x00 0xD0 0x7E 0xD5 0xB3 0x70 0x8B 0x77 0x66 0x5F 0x4E 0x3D 0x2B 0x2A 0x3D 0x12 0x23 0x5E 0x5F 0x7A
  # Binary:                <<0, 54, 14, 0, 208, 126, 213, 179, 112, 139, 119, 102, 95, 78, 61, 43, 42, 61, 18, 35, 94, 95, 122>>

  @phy_payload <<0, 54, 14, 0, 208, 126, 213, 179, 112, 139, 119, 102, 95, 78, 61, 43, 42, 61, 18, 35, 94, 95, 122>>

  #MHDR
  @m_type 0x00
  @rfu 0
  @major 0

  #MACPayload do
  @app_eui <<112, 179, 213, 126, 208, 0, 14, 54>>
  @dev_eui <<42, 43, 61, 78, 95, 102, 119, 139>>
  @dev_nonce <<18, 61>>

  @mic <<35, 94, 95, 122>>


  test "It should extract an JoinRequest packet." do
    packet = LoRaWAN.Decoder.decode @phy_payload

    # TODO: Implement test
    IO.puts inspect(packet)
  end

  test "It should extract an UnconfirmedDataUp packet (new)." do
    phy_payload = <<64, 208, 246, 125, 29, 0, 0, 0, 3, 172, 229, 114, 233, 126, 95>>
    packet = LoRaWAN.Decoder.decode phy_payload
    # TODO: Implement test
    IO.puts inspect(packet)
  end
end
