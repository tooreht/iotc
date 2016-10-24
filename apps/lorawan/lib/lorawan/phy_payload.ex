defmodule LoRaWAN.JoinRequest do
  defstruct [
    mtype: 0x00,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end

defmodule LoRaWAN.JoinAccept do
  defstruct [
    mtype: 0x01,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end

defmodule LoRaWAN.UnconfirmedDataUp do
  defstruct [
    mtype: 0x02,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end

defmodule LoRaWAN.UnconfirmedDataDown do
  defstruct [
    mtype: 0x03,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end

defmodule LoRaWAN.ConfirmedDataUp do
  defstruct [
    mtype: 0x04,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end

defmodule LoRaWAN.ConfirmedDataDown do
  defstruct [
    mtype: 0x05,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end

defmodule LoRaWAN.Proprietary do
  defstruct [
    mtype: 0x07,
    rfu: 0x00,
    major: 0x00,
    payload: nil,
    mic: nil
  ]
end

