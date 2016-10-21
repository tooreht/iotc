defmodule Semtech.PushData do
  @moduledoc """
  This module represents the Semtech PUSH_DATA packet type.
  
  ## PUSH_DATA packet (0x00)

  That packet type is used by the gateway mainly to forward the RF packets
  received, and associated metadata, to the server.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | random token
       3      | PUSH_DATA identifier 0x00
       4-11   | Gateway unique identifier (MAC address)
       12-end | JSON object, starting with {, ending with }
  """
  defstruct [
    version: nil,
    token: nil,
    identifier: 0x00,
    gateway_id: nil,
    payload: nil
  ]

  defmodule RxPk do
    @derive [Poison.Encoder]
    defstruct [
      rxpk: [],
      stat: nil
    ]

    defmodule Item do
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

    defmodule Status do
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
  end
end

defimpl Inspect, for: Semtech.PushData do
  def inspect(%Semtech.PushData{
                version: version,
                token: token,
                identifier: identifier,
                gateway_id: gateway_id,
                payload: payload}, _) do
    version  = inspect(version)
    token = inspect(token)
    identifier = inspect(identifier)
    gateway_id = inspect(gateway_id)
    payload = inspect(payload)
    
    """
    #Semtech.PushData<
      version: #{version},
      token: #{token},
      identifier: #{identifier},
      gateway_id: #{gateway_id},
      payload: #{payload}
    >
    """
  end
end
