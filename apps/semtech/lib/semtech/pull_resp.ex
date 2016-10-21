defmodule Semtech.PullResp do
  @moduledoc """
  This module represents the Semtech PULL_RESP packet type.

  ## PULL_RESP packet (0x03)

      That packet type is used by the server to send RF packets and associated
      metadata that will have to be emitted by the gateway.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | random token
       3      | PULL_RESP identifier 0x03
       4-end  | JSON object, starting with {, ending with }
  """
  defstruct [
    version: nil,
    token: nil,
    identifier: 0x03,
    payload: nil
  ]

  defmodule TxPk do
    @derive [Poison.Encoder]
    defstruct [
      txpk: [
        imme: nil,
        freq: nil,
        rfch: nil,
        powe: nil,
        modu: nil,
        datr: nil,
        codr: nil,
        ipol: nil,
        size: nil,
        data: nil
      ],
    ]
  end
end

defimpl Inspect, for: Semtech.PullResp do
  def inspect(%Semtech.PullResp{
                version: version,
                token: token,
                identifier: identifier,
                payload: payload}, _) do
    version  = inspect(version)
    token = inspect(token)
    identifier = inspect(identifier)
    payload = inspect(payload)
    
    """
    #Semtech.PullResp<
      version: #{version},
      token: #{token},
      identifier: #{identifier},
      payload: #{payload}
    >
    """
  end
end
