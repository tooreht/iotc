defmodule Semtech.RXPK do
  @derive [Poison.Encoder]
  defstruct [
    rxpk: [],
    stat: nil
  ]
end

defmodule Semtech.RXPK.Item do
  @derive [Poison.Encoder]
  defstruct [
    time: nil,
    tmst: nil,
    freq: nil,
    chan: nil,
    rfch: nil,
    stat: nil,
    modu: nil,
    datr: nil,
    datr: nil,
    codr: nil,
    rssi: nil,
    lsnr: nil,
    size: nil,
    data: nil
  ]
end

defmodule Semtech.RXPK.Status do
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
