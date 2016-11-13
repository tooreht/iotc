defmodule SemtechTest.Decoder.PUSH_DATA do
  use ExUnit.Case, async: true

  @version <<1>>
  @token <<56, 225>>
  @identifier <<0>>
  @gateway_id <<184, 39, 235, 255, 254, 255, 38, 178>>
  @rxpk_item <<0x7b, 0x22, 0x74, 0x6d, 0x73, 0x74, 0x22, 0x3a, 0x33, 0x30, 0x35, 0x39, 0x35, 0x38, 0x30, 0x37, 0x38, 0x37, 0x2c, 0x22, 0x74, 0x69, 0x6d, 0x65, 0x22, 0x3a, 0x22, 0x32, 0x30, 0x31, 0x36, 0x2d, 0x30, 0x39, 0x2d, 0x31, 0x37, 0x54, 0x32, 0x30, 0x3a, 0x33, 0x39, 0x3a, 0x35, 0x36, 0x2e, 0x39, 0x37, 0x31, 0x35, 0x31, 0x32, 0x5a, 0x22, 0x2c, 0x22, 0x63, 0x68, 0x61, 0x6e, 0x22, 0x3a, 0x34, 0x2c, 0x22, 0x72, 0x66, 0x63, 0x68, 0x22, 0x3a, 0x30, 0x2c, 0x22, 0x66, 0x72, 0x65, 0x71, 0x22, 0x3a, 0x38, 0x36, 0x37, 0x2e, 0x33, 0x30, 0x30, 0x30, 0x30, 0x30, 0x2c, 0x22, 0x73, 0x74, 0x61, 0x74, 0x22, 0x3a, 0x31, 0x2c, 0x22, 0x6d, 0x6f, 0x64, 0x75, 0x22, 0x3a, 0x22, 0x4c, 0x4f, 0x52, 0x41, 0x22, 0x2c, 0x22, 0x64, 0x61, 0x74, 0x72, 0x22, 0x3a, 0x22, 0x53, 0x46, 0x37, 0x42, 0x57, 0x31, 0x32, 0x35, 0x22, 0x2c, 0x22, 0x63, 0x6f, 0x64, 0x72, 0x22, 0x3a, 0x22, 0x34, 0x2f, 0x35, 0x22, 0x2c, 0x22, 0x6c, 0x73, 0x6e, 0x72, 0x22, 0x3a, 0x39, 0x2e, 0x35, 0x2c, 0x22, 0x72, 0x73, 0x73, 0x69, 0x22, 0x3a, 0x2d, 0x35, 0x35, 0x2c, 0x22, 0x73, 0x69, 0x7a, 0x65, 0x22, 0x3a, 0x31, 0x35, 0x2c, 0x22, 0x64, 0x61, 0x74, 0x61, 0x22, 0x3a, 0x22, 0x51, 0x43, 0x7a, 0x43, 0x34, 0x78, 0x77, 0x41, 0x41, 0x41, 0x41, 0x44, 0x62, 0x46, 0x63, 0x67, 0x5a, 0x6a, 0x63, 0x43, 0x22, 0x7d>>
  @status <<0x22, 0x73, 0x74, 0x61, 0x74, 0x22, 0x3a, 0x7b, 0x22, 0x74, 0x69, 0x6d, 0x65, 0x22, 0x3a, 0x22, 0x32, 0x30, 0x31, 0x34, 0x2d, 0x30, 0x31, 0x2d, 0x31, 0x32, 0x20, 0x30, 0x38, 0x3a, 0x35, 0x39, 0x3a, 0x32, 0x38, 0x20, 0x47, 0x4d, 0x54, 0x22, 0x2c, 0x22, 0x6c, 0x61, 0x74, 0x69, 0x22, 0x3a, 0x34, 0x36, 0x2e, 0x32, 0x34, 0x30, 0x30, 0x30, 0x2c, 0x22, 0x6c, 0x6f, 0x6e, 0x67, 0x22, 0x3a, 0x33, 0x2e, 0x32, 0x35, 0x32, 0x33, 0x30, 0x2c, 0x22, 0x61, 0x6c, 0x74, 0x69, 0x22, 0x3a, 0x31, 0x34, 0x35, 0x2c, 0x22, 0x72, 0x78, 0x6e, 0x62, 0x22, 0x3a, 0x32, 0x2c, 0x22, 0x72, 0x78, 0x6f, 0x6b, 0x22, 0x3a, 0x32, 0x2c, 0x22, 0x72, 0x78, 0x66, 0x77, 0x22, 0x3a, 0x32, 0x2c, 0x22, 0x61, 0x63, 0x6b, 0x72, 0x22, 0x3a, 0x31, 0x30, 0x30, 0x2e, 0x30, 0x2c, 0x22, 0x64, 0x77, 0x6e, 0x62, 0x22, 0x3a, 0x32, 0x2c, 0x22, 0x74, 0x78, 0x6e, 0x62, 0x22, 0x3a, 0x32, 0x7d>>
  test "It should extract PUSH_DATA with one rxpk item." do
    payload = <<0x7b, 0x22, 0x72, 0x78, 0x70, 0x6b, 0x22, 0x3a, 0x5b>> <> @rxpk_item <> <<0x5d, 0x7d>>

    udp_payload = @version <> @token <> @identifier <> @gateway_id <> payload

    packet = Semtech.Decoder.decode(udp_payload)
    assert packet.version == 1
    assert packet.token == 14561
    assert packet.identifier == 0
    assert packet.gateway_id == "B827EBFFFEFF26B2"
    assert packet.payload == %Semtech.PushData.RxPk{
      rxpk: [
        %Semtech.PushData.RxPk.Item{
          tmst: 3059580787,
          time: "2016-09-17T20:39:56.971512Z",
          chan: 4,
          rfch: 0,
          freq: 867.300000,
          stat: 1,
          modu: "LORA",
          datr: "SF7BW125",
          codr: "4/5",
          lsnr: 9.5,
          rssi: -55,
          size: 15,
          data: "QCzC4xwAAAADbFcgZjcC"
        }
      ]
    }
  end

  test "It should extract PUSH_DATA with two rxpk items." do
    payload = <<0x7b, 0x22, 0x72, 0x78, 0x70, 0x6b, 0x22, 0x3a, 0x5b>> <> @rxpk_item <> <<0x2c>> <> @rxpk_item <> <<0x5d, 0x7d>>

    udp_payload = @version <> @token <> @identifier <> @gateway_id <> payload

    packet = Semtech.Decoder.decode(udp_payload)
    assert packet.version == 1
    assert packet.token == 14561
    assert packet.identifier == 0
    assert packet.gateway_id == "B827EBFFFEFF26B2"
    assert packet.payload == %Semtech.PushData.RxPk{
      rxpk: [
        %Semtech.PushData.RxPk.Item{
          tmst: 3059580787,
          time: "2016-09-17T20:39:56.971512Z",
          chan: 4,
          rfch: 0,
          freq: 867.300000,
          stat: 1,
          modu: "LORA",
          datr: "SF7BW125",
          codr: "4/5",
          lsnr: 9.5,
          rssi: -55,
          size: 15,
          data: "QCzC4xwAAAADbFcgZjcC"
        },
        %Semtech.PushData.RxPk.Item{
          tmst: 3059580787,
          time: "2016-09-17T20:39:56.971512Z",
          chan: 4,
          rfch: 0,
          freq: 867.300000,
          stat: 1,
          modu: "LORA",
          datr: "SF7BW125",
          codr: "4/5",
          lsnr: 9.5,
          rssi: -55,
          size: 15,
          data: "QCzC4xwAAAADbFcgZjcC"
        }
      ]
    }
  end

  test "It should extract PUSH_DATA with one rxpk item and a status." do
    payload = <<0x7b, 0x22, 0x72, 0x78, 0x70, 0x6b, 0x22, 0x3a, 0x5b>> <> @rxpk_item <> <<0x5d, 0x2c>> <> @status <> <<0x7d>>

    udp_payload = @version <> @token <> @identifier <> @gateway_id <> payload

    packet = Semtech.Decoder.decode(udp_payload)
    assert packet.version == 1
    assert packet.token == 14561
    assert packet.identifier == 0
    assert packet.gateway_id == "B827EBFFFEFF26B2"
    assert packet.payload == %Semtech.PushData.RxPk{
      rxpk: [
        %Semtech.PushData.RxPk.Item{
          tmst: 3059580787,
          time: "2016-09-17T20:39:56.971512Z",
          chan: 4,
          rfch: 0,
          freq: 867.300000,
          stat: 1,
          modu: "LORA",
          datr: "SF7BW125",
          codr: "4/5",
          lsnr: 9.5,
          rssi: -55,
          size: 15,
          data: "QCzC4xwAAAADbFcgZjcC"
        }
      ],
      stat: %Semtech.PushData.RxPk.Status{
        time: "2014-01-12 08:59:28 GMT",
        lati: 46.24000,
        long: 3.25230,
        alti: 145,
        rxnb: 2,
        rxok: 2,
        rxfw: 2,
        ackr: 100.0,
        dwnb: 2,
        txnb: 2
      }
    }
  end

  test "It should extract PUSH_DATA with no rxpk item but a status." do
    payload = <<0x7b>> <> @status <> <<0x7d>>

    udp_payload = @version <> @token <> @identifier <> @gateway_id <> payload

    packet = Semtech.Decoder.decode(udp_payload)
    assert packet.version == 1
    assert packet.token == 14561
    assert packet.identifier == 0
    assert packet.gateway_id == "B827EBFFFEFF26B2"
    assert packet.payload == %Semtech.PushData.RxPk{
      stat: %Semtech.PushData.RxPk.Status{
        time: "2014-01-12 08:59:28 GMT",
        lati: 46.24000,
        long: 3.25230,
        alti: 145,
        rxnb: 2,
        rxok: 2,
        rxfw: 2,
        ackr: 100.0,
        dwnb: 2,
        txnb: 2
      }
    }
  end
end

defmodule SemtechTest.Decoder.PushAck do
  use ExUnit.Case, async: true
  # TODO: Implement!
end

defmodule SemtechTest.Decoder.PullData do
  use ExUnit.Case, async: true
  # TODO: Implement!
end

defmodule SemtechTest.Decoder.PullAck do
  use ExUnit.Case, async: true
  # TODO: Implement!
end

defmodule SemtechTest.Decoder.PullResp do
  use ExUnit.Case, async: true
  # TODO: Implement!
end

defmodule SemtechTest.Decoder.TxAck do
  use ExUnit.Case, async: true
  # TODO: Implement!
end
