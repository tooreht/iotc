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

defimpl Inspect, for: LoRaWAN.ConfirmedDataUp do
  def inspect(%LoRaWAN.ConfirmedDataUp{
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
    #LoRaWAN.ConfirmedDataUp<
      mtype: #{mtype},
      rfu: #{rfu},
      major: #{major},
      mac_payload: #{mac_payload},
      mic: #{mic}
    >
    """
  end
end
