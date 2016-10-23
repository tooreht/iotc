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

  defmodule TxPkAck do
    @moduledoc """
    This module represents a TxPkAck JSON object item.

    ## Structure

    The root object of TX_ACK packet must contain an object named "txpk_ack":

    ``` json
    {
      "txpk_ack": {...}
    }
    ```

    That object contain status information concerning the associated PULL_RESP packet.

         Name |  Type  | Function
        :----:|:------:|------------------------------------------------------------------------------
        error | string | Indication about success or type of failure that occured for downlink request.

    The possible values of "error" field are:

         Value             | Definition
        :-----------------:|---------------------------------------------------------------------
         NONE              | Packet has been programmed for downlink
         TOO_LATE          | Rejected because it was already too late to program this packet for downlink
         TOO_EARLY         | Rejected because downlink packet timestamp is too much in advance
         COLLISION_PACKET  | Rejected because there was already a packet programmed in requested timeframe
         COLLISION_BEACON  | Rejected because there was already a beacon planned in requested timeframe
         TX_FREQ           | Rejected because requested frequency is not supported by TX RF chain
         TX_POWER          | Rejected because requested power is not supported by gateway
         GPS_UNLOCKED      | Rejected because GPS is unlocked, so GPS timestamp cannot be used

    Examples (white-spaces, indentation and newlines added for readability):

    ``` json
    {"txpk_ack":{
      "error":"COLLISION_PACKET"
    }}
    ```
    """

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
