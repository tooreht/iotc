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
    mac_payload: nil,
    mic: nil
  ]

  defmodule MACPayload do
    defstruct [
      devAddr: nil,
      fCtrl: nil,
      fCnt: nil,
      fOpts: nil,
      fPort: nil,
      frmPayload: nil
    ]

    defmodule FCtrl do
      defstruct [
        adr: nil,
        adrAckReq: nil,
        ack: nil,
        rfu: nil,
        fOptsLen: nil
      ]
    end
  end
end

defimpl Inspect, for: LoRaWAN.UnconfirmedDataUp do
  def inspect(%LoRaWAN.UnconfirmedDataUp{
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
    #LoRaWAN.UnconfirmedDataUp<
      mtype: #{mtype},
      rfu: #{rfu},
      major: #{major},
      mac_payload: #{mac_payload},
      mic: #{mic}
    >
    """
  end
end
