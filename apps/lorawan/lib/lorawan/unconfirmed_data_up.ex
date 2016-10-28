defmodule LoRaWAN.UnconfirmedDataUp do
  @moduledoc """
  This module represents the LoRaWAN UnconfirmedDataUp packet type.

  ## UnconfirmedDataUp packet (0x02)

      That packet type is used by the mote to send a message to an application
      without requesting a confirm message.

  """
  defstruct [
    mtype: 0x02,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end
