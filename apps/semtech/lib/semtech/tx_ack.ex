defmodule Semtech.TxAck do
  @moduledoc """
  This module represents the Semtech TX_ACK packet type.

  ## TX_ACK packet (0x05)

  That packet type is used by the gateway to send a feedback to the server
  to inform if a downlink request has been accepted or rejected by the gateway.
  The datagram may optionnaly contain a JSON string to give more details on
  acknoledge. If no JSON is present (empty string), this means than no error
  occured.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | same token as the PULL_RESP packet to acknowledge
       3      | TX_ACK identifier 0x05
       4-end  | [optional] JSON object, starting with {, ending with }
  """
  defstruct [
    version: nil,
    token: nil,
    identifier: 0x05,
    payload: nil
  ]

  defmodule TxPk do
    @derive [Poison.Encoder]
    defstruct [
      txpk_ack: [
        error: nil,
      ],
    ]
  end
end

defimpl Inspect, for: Semtech.TxAck do
  def inspect(%Semtech.TxAck{
                version: version,
                token: token,
                identifier: identifier,
                payload: payload}, _) do
    version  = inspect(version)
    token = inspect(token)
    identifier = inspect(identifier)
    payload = inspect(payload)
    
    """
    #Semtech.TxAck<
      version: #{version},
      token: #{token},
      identifier: #{identifier},
      payload: #{payload}
    >
    """
  end
end
