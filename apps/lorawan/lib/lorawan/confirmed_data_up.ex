defmodule LoRaWAN.ConfirmedDataUp do
  @moduledoc """
  This module represents the LoRaWAN ConfirmedDataUp packet type.

  ## ConfirmedDataUp packet (0x04)

      That packet type is used by the mote to send a message to an application
      requesting a confirm message.

  """
  defstruct [
    mtype: 0x04,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end
