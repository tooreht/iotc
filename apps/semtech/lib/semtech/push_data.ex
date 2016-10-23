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
    @moduledoc """
    This module represents the RxPk packet JSON object.

    ## Structure

    The root object can contain an array named "rxpk":

    ``` json
    {
      "rxpk":[ {...}, ...]
    }
    ```

    The root object can also contain an object named "stat" :

    ``` json
    {
      "rxpk":[ {...}, ...],
      "stat":{...}
    }
    ```

    It is possible for a packet to contain no "rxpk" array but a "stat" object.

    ``` json
    {
      "stat":{...}
    }
    ```
    """

    @derive [Poison.Encoder]
    defstruct [
      rxpk: [],
      stat: nil
    ]

    defmodule Item do
      @moduledoc """
      This module represents a RxPk JSON object item.

      ## Structure

      That array contains at least one JSON object, each object contain a RF packet 
      and associated metadata with the following fields:

           Name |  Type  | Function
          :----:|:------:|--------------------------------------------------------------
           time | string | UTC time of pkt RX, us precision, ISO 8601 'compact' format
           tmst | number | Internal timestamp of "RX finished" event (32b unsigned)
           freq | number | RX central frequency in MHz (unsigned float, Hz precision)
           chan | number | Concentrator "IF" channel used for RX (unsigned integer)
           rfch | number | Concentrator "RF chain" used for RX (unsigned integer)
           stat | number | CRC status: 1 = OK, -1 = fail, 0 = no CRC
           modu | string | Modulation identifier "LORA" or "FSK"
           datr | string | LoRa datarate identifier (eg. SF12BW500)
           datr | number | FSK datarate (unsigned, in bits per second)
           codr | string | LoRa ECC coding rate identifier
           rssi | number | RSSI in dBm (signed integer, 1 dB precision)
           lsnr | number | Lora SNR ratio in dB (signed float, 0.1 dB precision)
           size | number | RF packet payload size in bytes (unsigned integer)
           data | string | Base64 encoded RF packet payload, padded

      Example (white-spaces, indentation and newlines added for readability):

      ``` json
      {"rxpk":[
        {
          "time":"2013-03-31T16:21:17.528002Z",
          "tmst":3512348611,
          "chan":2,
          "rfch":0,
          "freq":866.349812,
          "stat":1,
          "modu":"LORA",
          "datr":"SF7BW125",
          "codr":"4/6",
          "rssi":-35,
          "lsnr":5.1,
          "size":32,
          "data":"-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84"
        },{
          "time":"2013-03-31T16:21:17.530974Z",
          "tmst":3512348514,
          "chan":9,
          "rfch":1,
          "freq":869.1,
          "stat":1,
          "modu":"FSK",
          "datr":50000,
          "rssi":-75,
          "size":16,
          "data":"VEVTVF9QQUNLRVRfMTIzNA=="
        },{
          "time":"2013-03-31T16:21:17.532038Z",
          "tmst":3316387610,
          "chan":0,
          "rfch":0,
          "freq":863.00981,
          "stat":1,
          "modu":"LORA",
          "datr":"SF10BW125",
          "codr":"4/7",
          "rssi":-38,
          "lsnr":5.5,
          "size":32,
          "data":"ysgRl452xNLep9S1NTIg2lomKDxUgn3DJ7DE+b00Ass"
        }
      ]}
      ```
      """

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
      @moduledoc """
      This module represents a RxPk Status JSON object.

      ## Structure

      That object contains the status of the gateway, with the following fields:

           Name |  Type  | Function
          :----:|:------:|--------------------------------------------------------------
           time | string | UTC 'system' time of the gateway, ISO 8601 'expanded' format
           lati | number | GPS latitude of the gateway in degree (float, N is +)
           long | number | GPS latitude of the gateway in degree (float, E is +)
           alti | number | GPS altitude of the gateway in meter RX (integer)
           rxnb | number | Number of radio packets received (unsigned integer)
           rxok | number | Number of radio packets received with a valid PHY CRC
           rxfw | number | Number of radio packets forwarded (unsigned integer)
           ackr | number | Percentage of upstream datagrams that were acknowledged
           dwnb | number | Number of downlink datagrams received (unsigned integer)
           txnb | number | Number of packets emitted (unsigned integer)

      Example (white-spaces, indentation and newlines added for readability):

      ``` json
      {"stat":{
        "time":"2014-01-12 08:59:28 GMT",
        "lati":46.24000,
        "long":3.25230,
        "alti":145,
        "rxnb":2,
        "rxok":2,
        "rxfw":2,
        "ackr":100.0,
        "dwnb":2,
        "txnb":2
      }}
      ```
      """

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
