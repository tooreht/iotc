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
    mac_payload: nil,
    mic: nil
  ]
end

defimpl Inspect, for: LoRaWAN.ConfirmedDataDown do
  def inspect(%LoRaWAN.ConfirmedDataDown{
                mtype: mtype,
                rfu: rfu,
                major: major,
                mac_payload: mac_payload,
                mic: mic}, _) do
    mtype  = inspect(mtype)
    rfu = inspect(rfu)
    mac_payload = inspect(mac_payload)
    mic = inspect(mic)
    
    """
    #LoRaWAN.ConfirmedDataDown<
      mtype: #{mtype},
      rfu: #{rfu},
      major: #{major},
      mac_payload: #{mac_payload},
      mic: #{mic}
    >
    """
  end
end
