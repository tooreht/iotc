defmodule LoRaWAN.UnconfirmedDataDown do
  @moduledoc """
  This module represents the LoRaWAN UnconfirmedDataDown packet type.

  ## UnconfirmedDataDown packet (0x03)

      That packet type is used by the server to send a message from an application to a mote
      without requesting a confirm message.

  """
  defstruct [
    mtype: 0x03,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end
