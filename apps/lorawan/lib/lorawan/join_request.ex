defmodule LoRaWAN.JoinRequest do
@moduledoc """
  This module represents the LoRaWAN JoinRequest packet type.

  ## JoinRequest packet (0x00)

      That packet type is used by the mote to ask to join a LoRaWAN Network

  """
  defstruct [
    mtype: 0x00,
    rfu: 0x00,
    major: 0x00,
    mac_payload: nil,
    mic: nil
  ]

   defmodule MACPayload do
    defstruct [
      appEUI: nil,
      devEUI: nil,
      devNonce: nil
    ]
  end
end

defimpl Inspect, for: LoRaWAN.JoinRequest do
  def inspect(%LoRaWAN.JoinRequest{
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
    #LoRaWAN.JoinRequest<
      mtype: #{mtype},
      rfu: #{rfu},
      major: #{major},
      mac_payload: #{mac_payload},
      mic: #{mic}
    >
    """
  end
end
