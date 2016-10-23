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
    @moduledoc """
    This module represents the TxPk packet JSON object.

    ## Structure

    The root object of PULL_RESP packet must contain an object named "txpk":

    ``` json
    {
      "txpk": {...}
    }
    ```

    That object contain a RF packet to be emitted and associated metadata with the following fields: 

         Name |  Type  | Function
        :----:|:------:|--------------------------------------------------------------
         imme | bool   | Send packet immediately (will ignore tmst & time)
         tmst | number | Send packet on a certain timestamp value (will ignore time)
         time | string | Send packet at a certain time (GPS synchronization required)
         freq | number | TX central frequency in MHz (unsigned float, Hz precision)
         rfch | number | Concentrator "RF chain" used for TX (unsigned integer)
         powe | number | TX output power in dBm (unsigned integer, dBm precision)
         modu | string | Modulation identifier "LORA" or "FSK"
         datr | string | LoRa datarate identifier (eg. SF12BW500)
         datr | number | FSK datarate (unsigned, in bits per second)
         codr | string | LoRa ECC coding rate identifier
         fdev | number | FSK frequency deviation (unsigned integer, in Hz) 
         ipol | bool   | Lora modulation polarization inversion
         prea | number | RF preamble size (unsigned integer)
         size | number | RF packet payload size in bytes (unsigned integer)
         data | string | Base64 encoded RF packet payload, padding optional
         ncrc | bool   | If true, disable the CRC of the physical layer (optional)

    Most fields are optional.
    If a field is omitted, default parameters will be used.

    Examples (white-spaces, indentation and newlines added for readability):

    ``` json
    {"txpk":{
      "imme":true,
      "freq":864.123456,
      "rfch":0,
      "powe":14,
      "modu":"LORA",
      "datr":"SF11BW125",
      "codr":"4/6",
      "ipol":false,
      "size":32,
      "data":"H3P3N2i9qc4yt7rK7ldqoeCVJGBybzPY5h1Dd7P7p8v"
    }}
    ```

    ``` json
    {"txpk":{
      "imme":true,
      "freq":861.3,
      "rfch":0,
      "powe":12,
      "modu":"FSK",
      "datr":50000,
      "fdev":3000,
      "size":32,
      "data":"H3P3N2i9qc4yt7rK7ldqoeCVJGBybzPY5h1Dd7P7p8v"
    }}
    ```
    """

    @derive [Poison.Encoder]
    defstruct [
      txpk: [
        imme: nil,
        tmst: nil,
        time: nil,
        freq: nil,
        rfch: nil,
        powe: nil,
        modu: nil,
        datr: nil,
        datr: nil,
        codr: nil,
        fdev: nil,
        ipol: nil,
        prea: nil,
        size: nil,
        data: nil,
        ncrc: nil
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
