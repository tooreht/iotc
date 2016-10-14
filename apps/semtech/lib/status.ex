defmodule Semtech.Status do
  @derive [Poison.Encoder]
  defstruct [
    time: nil,
    lati: nil,
    long: nil,
    alti: nil,
    rxnb: nil,
    rxok: nil,
    rxfw: nil,
    ackr: nil,
    dwnb: nil,
    txnb: nil
  ]
end