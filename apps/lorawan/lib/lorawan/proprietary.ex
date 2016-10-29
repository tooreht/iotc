defmodule LoRaWAN.Proprietary do
  @moduledoc """
  This module represents the LoRaWAN proprietary packet type.

  ## proprietary packet (0x07)

      That packet type is used by the server or mote to send a message from or to an application.
      The implementation is proprietary.

  """
  defstruct [
    mtype: 0x07,
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
        rfu: nil,
        fOptsLen: nil
      ]
    end
  end
end

defimpl Inspect, for: LoRaWAN.Proprietary do
  def inspect(%LoRaWAN.Proprietary{
                mtype: mtype,
                rfu: rfu,
                payload: payload,
                mic: mic}, _) do
    mtype  = inspect(mtype)
    rfu = inspect(rfu)
    payload = inspect(payload)
    mic = inspect(mic)
    
    """
    #LoRaWAN.Proprietary<
      mtype: #{mtype},
      rfu: #{rfu},
      payload: #{payload},
      mic: #{mic}
    >
    """
  end
end
