defmodule LoRaWAN.MACPayload do
  defstruct [
    devAddr: nil,
    fCtrl: nil,
    fCnt: nil,
    fOpts: nil,
    fPort: nil,
    payload: nil
  ]
end
