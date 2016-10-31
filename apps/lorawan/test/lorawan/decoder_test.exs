defmodule HandlerTest do
  use ExUnit.Case
  # Origin Base64 Message:  QOvHuxwAAAADifcrgYr0
  # HEX:                    0x40 0xEB 0xC7 0xBB 0x1C 0x00 0x00 0x00 0x03 0x89 0xF7 0x2B 0x81 0x8A 0xF4
  # Binary:                 <<64, 235, 199, 187, 28, 0, 0, 0, 3, 137, 247, 43, 129, 138, 244>>

  @message <<64, 235, 199, 187, 28, 0, 0, 0, 3, 137, 247, 43, 129, 138, 244>>

  #MHDR
  @mtype 0x02
  @major 0
  @rfu 0
  @mic <<43, 129, 138, 244>>


  #MACPayload do
  @devAddr <<28, 187, 199, 235>>
  @fCnt 0
  @fOpts ""
  @fPort <<3>>
  @frmPayload <<137, 247>>

  #FCTRL
  @adr 0
  @adrAckReq 0
  @ack 0
  @rfu 0
  @fOptsLen 0

  test "It should extract an UnconfirmedDataUp packet." do
    packet = LoRaWAN.Decoder.decode @message
    assert packet.mtype == @mtype
    assert packet.rfu == @rfu
    assert packet.major == @major
    assert packet.mic == @mic
    assert packet.payload ==  %LoRaWAN.UnconfirmedDataUp.MACPayload{
      devAddr: @devAddr,
      fCnt: @fCnt,
      fCtrl: %LoRaWAN.UnconfirmedDataUp.MACPayload.FCtrl{
        ack: @ack,
        adr: @adr,
        adrAckReq: @adrAckReq,
        fOptsLen: @fOptsLen,
        rfu: 0
        },
      fOpts: "",
      fPort: @fPort,
      frmPayload: @frmPayload
    }
  end

  # Origin Base64 Message: ADYOANB+1bNwi3dmX049Kyo9EiNeX3o=
  # HEX:                   0x00 0x36 0x0E 0x00 0xD0 0x7E 0xD5 0xB3 0x70 0x8B 0x77 0x66 0x5F 0x4E 0x3D 0x2B 0x2A 0x3D 0x12 0x23 0x5E 0x5F 0x7A
  # Binary:                <<0, 54, 14, 0, 208, 126, 213, 179, 112, 139, 119, 102, 95, 78, 61, 43, 42, 61, 18, 35, 94, 95, 122>>

  @message <<0, 54, 14, 0, 208, 126, 213, 179, 112, 139, 119, 102, 95, 78, 61, 43, 42, 61, 18, 35, 94, 95, 122>>

  #MHDR
  @mtype 0x00
  @major 0
  @rfu 0
  @mic <<35, 94, 95, 122>>


  #MACPayload do
  @appEUI <<112, 179, 213, 126, 208, 0, 14, 54>>
  @devEUI <<42, 43, 61, 78, 95, 102, 119, 139>>
  @devNonce <<18, 61>>

  test "It should extract an JoinRequest packet." do
    packet = LoRaWAN.Decoder.decode @message

    assert packet.mtype == @mtype
    assert packet.rfu == @rfu
    assert packet.major == @major
    assert packet.mic == @mic
    assert packet.payload == %LoRaWAN.JoinRequest.MACPayload{
      appEUI: @appEUI,
      devEUI: @devEUI,
      devNonce: @devNonce
    }
  end
end
