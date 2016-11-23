defmodule LoRaWAN.JoinAccept do
@moduledoc """
  This module represents the LoRaWAN JoinAccept packet type.

  ## JoinAccept packet (0x01)

      That packet type is used by the server to accept a joinrequest by a mote

  """
  defstruct [
    mtype: 0x01,
    rfu: 0x00,
    major: 0x00,
    mac_payload: nil,
    mic: nil
  ]

   defmodule MACPayload do
    defstruct [
      appNonce: nil,
      netID: nil,
      devAddr: nil,
      dlSettings: nil,
      rxDelay: nil,
      cfList: nil
    ]
  end
end

defimpl Inspect, for: LoRaWAN.JoinAccept do
  def inspect(%LoRaWAN.JoinAccept{
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
    #LoRaWAN.JoinAccept<
      mtype: #{mtype},
      rfu: #{rfu},
      major: #{major},
      mac_payload: #{mac_payload},
      mic: #{mic}
    >
    """
  end
end
