defmodule LoRaWAN.MACHandlerTest do
  use ExUnit.Case, async: true
  # alias LoRaWAN.Packet

  test "it should get a LinkADRAns MAC Command." do
    phy_payload = <<64, 221, 83, 103, 169, 130, 138, 6, 3, 7, 20, 44, 180, 122, 249, 213, 75, 180, 131, 118, 203, 232, 90, 191, 46>>
    packet = LoRaWAN.Decoder.decode phy_payload

    LoRaWAN.MACHandler.handle_mac_commands(packet)
  end

end
