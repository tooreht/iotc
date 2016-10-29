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
        fPending: nil,
        fOptsLen: nil
      ]
    end
  end
end

defimpl Inspect, for: LoRaWAN.ConfirmedDataDown do
  def inspect(%LoRaWAN.ConfirmedDataDown{
                mtype: mtype,
                rfu: rfu,
                payload: payload,
                mic: mic}, _) do
    mtype  = inspect(mtype)
    rfu = inspect(rfu)
    payload = inspect(payload)
    mic = inspect(mic)
    
    """
    #LoRaWAN.ConfirmedDataDown<
      mtype: #{mtype},
      rfu: #{rfu},
      payload: #{payload},
      mic: #{mic}
    >
    """
  end
end
