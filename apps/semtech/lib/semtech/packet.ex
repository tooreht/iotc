defmodule Semtech.Packet do
  defstruct [
    version: nil,
    token: nil,
    identifier: nil,
    gateway_id: nil,
    payload: nil
  ]

  defmodule RXPK do
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

  defmodule TXPK do
    # TODO: Implement!
    defstruct []
  end

  defmodule TXPK_ACK do
    # TODO: Implement!
    defstruct []
  end

  def json_decode(identifier, payload) do
    cond do
      identifier == 0x00 -> Poison.decode!(payload, as: %RXPK{rxpk: [%RXPK.Item{}], stat: %RXPK.Status{}})
      identifier == 0x03 -> Poison.decode!(payload, as: %TXPK{})
      identifier == 0x05 -> Poison.decode!(payload, as: %TXPK_ACK{})
      true               -> payload
    end
  end
end



defimpl Inspect, for: Semtech.Packet do
  def inspect(%Semtech.Packet{
                version: version,
                token: token,
                identifier: identifier,
                gateway_id: gateway_id,
                payload: payload}, _) do
    payload = inspect(Semtech.Packet.json_decode(identifier, payload))
    gateway_id = inspect(Integer.to_char_list(gateway_id, 16))
    identifier = inspect(identifier)
    token = inspect(token)
    version  = inspect(version)
    
    """
    #Semtech.Packet<
      version: #{version},
      token: #{token},
      identifier: #{identifier},
      gateway_id: #{gateway_id},
      payload: #{payload}
    >
    """
  end
end
