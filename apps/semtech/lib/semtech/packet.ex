defmodule Semtech.Packet do
  defstruct(
    version: 0,
    token: 0,
    identifier: 0,
    gateway_id: 0,
    payload: "{}"
  )
end
