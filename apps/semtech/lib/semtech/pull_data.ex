defmodule Semtech.PullData do
  @moduledoc """
  This module represents the Semtech PULL_DATA packet type.

  ## PULL_DATA packet (0x02)

  That packet type is used by the gateway to poll data from the server.

  This data exchange is initialized by the gateway because it might be
  impossible for the server to send packets to the gateway if the gateway is
  behind a NAT.

  When the gateway initialize the exchange, the network route towards the
  server will open and will allow for packets to flow both directions.
  The gateway must periodically send PULL_DATA packets to be sure the network
  route stays open for the server to be used at any time.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | random token
       3      | PULL_DATA identifier 0x02
       4-11   | Gateway unique identifier (MAC address)
  """
  defstruct [
    version: nil,
    token: nil,
    identifier: 0x02,
    gateway_id: nil,
  ]
end

defimpl Inspect, for: Semtech.PullData do
  def inspect(%Semtech.PullData{
                version: version,
                token: token,
                identifier: identifier,
                gateway_id: gateway_id}, _) do
    version  = inspect(version)
    token = inspect(token)
    identifier = inspect(identifier)
    gateway_id = inspect(gateway_id)
    
    """
    #Semtech.PullData<
      version: #{version},
      token: #{token},
      identifier: #{identifier},
      gateway_id: #{gateway_id}
    >
    """
  end
end
