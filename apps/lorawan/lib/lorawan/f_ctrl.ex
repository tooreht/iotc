defmodule LoRaWAN.FCtrl do
  defmodule LoRaWAN.FCtrl.DownLink do
    defstruct [
      adr: nil,
      adrAckReq: nil,
      ack: nil,
      fPending: nil,
      fOptsLen: nil
    ]
  end

  defmodule LoRaWAN.FCtrl.UpLink do
    defstruct [
      adr: nil,
      adrAckReq: nil,
      ack: nil,
      rfu: nil,
      fOptsLen: nil
    ]
  end
end
