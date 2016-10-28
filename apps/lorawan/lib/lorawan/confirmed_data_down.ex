defmodule LoRaWAN.ConfirmedDataDown do
  @moduledoc """
  This module represents the LoRaWAN ConfirmedDataDown packet type.

  ## ConfirmedDataDown packet (0x05)

      That packet type is used by the server to send a message from an application to a mote
      requesting a confirm message.

  """
  defstruct [
    mtype: 0x05,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end
