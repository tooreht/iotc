defmodule LoRaWAN.JoinAccept do
@moduledoc """
  This module represents the LoRaWAN JoinAccept packet type.

  ## JoinRequest packet (0x01)

      That packet type is used by the server to accept a joinrequest by a mote

  """
  defstruct [
    mtype: 0x01,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end
