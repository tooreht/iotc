defmodule Semtech.Packet do
  defstruct [
    version: nil,
    token: nil,
    identifier: nil,
    gateway_id: nil,
    payload: nil
  ]
end
