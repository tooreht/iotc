defmodule Semtech.PushAck do
  @moduledoc """
  This module represents the Semtech PUSH_ACK packet type.

  ## PUSH_ACK packet (0x01)

  That packet type is used by the server to acknowledge immediately all the
  PUSH_DATA packets received.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | same token as the PUSH_DATA packet to acknowledge
       3      | PUSH_ACK identifier 0x01
  """
  defstruct [
    version: nil,
    token: nil,
    identifier: 0x01,
  ]
end

defimpl Inspect, for: Semtech.PushAck do
  def inspect(%Semtech.PushAck{
                version: version,
                token: token,
                identifier: identifier}, _) do
    version  = inspect(version)
    token = inspect(token)
    identifier = inspect(identifier)
    
    """
    #Semtech.PushAck<
      version: #{version},
      token: #{token},
      identifier: #{identifier}
    >
    """
  end
end
