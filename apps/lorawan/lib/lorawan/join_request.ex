defmodule LoRaWAN.JoinRequest do
@moduledoc """
  This module represents the LoRaWAN JoinRequest packet type.

  ## JoinRequest packet (0x00)

      That packet type is used by the mote ask to join a LoRaWAN Network

  """
  defstruct [
    mtype: 0x00,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end
