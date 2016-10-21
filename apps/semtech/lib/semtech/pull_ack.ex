defmodule Semtech.PullAck do
  @moduledoc """
  This module represents the Semtech PULL_ACK packet type.

  ## PULL_ACK packet (0x04)

      That packet type is used by the server to confirm that the network route is
      open and that the server can send PULL_RESP packets at any time.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | same token as the PULL_DATA packet to acknowledge
       3      | PULL_ACK identifier 0x04
  """
  defstruct [
    version: nil,
    token: nil,
    identifier: 0x04,
  ]
end

defimpl Inspect, for: Semtech.PullAck do
  def inspect(%Semtech.PullAck{
                version: version,
                token: token,
                identifier: identifier}, _) do
    version  = inspect(version)
    token = inspect(token)
    identifier = inspect(identifier)
    
    """
    #Semtech.PullAck<
      version: #{version},
      token: #{token},
      identifier: #{identifier}
    >
    """
  end
end
