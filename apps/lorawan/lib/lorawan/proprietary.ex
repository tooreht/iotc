defmodule LoRaWAN.Proprietary do
  @moduledoc """
  This module represents the LoRaWAN proprietary packet type.

  ## proprietary packet (0x07)

      That packet type is used by the server or mote to send a message from or to an application.
      The implementation is proprietary.

  """
  defstruct [
    mtype: 0x07,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end
