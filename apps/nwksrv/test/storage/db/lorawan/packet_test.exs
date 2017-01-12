defmodule NwkSrv.Storage.DB.LoRaWAN.PacketTest do
  use NwkSrv.ModelCase

  alias NwkSrv.LoRaWAN.Packet
  alias NwkSrv.Storage
  alias NwkSrv.User

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}
    application = Repo.insert! %NwkSrv.LoRaWAN.Application{
                              app_eui: "704FD42E1A0C15C8",
                              user_id: user.id
                            }
    device_address = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "79D2A146", last_assigned: Ecto.DateTime.utc}
    node = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{
      dev_eui: "0000000079D2A146",
      device_address_id: device_address.id,
      nwk_s_key: "838401AC11E4E1DF4C6AD56A0747D2C4",
      application_id: application.id,
      user_id: user.id
    }
    valid_attrs = %{
                    type: 3,
                    number: 123,
                    frequency: "868.0",
                    channel: 42,
                    modulation: "LORA" ,
                    data_rate: "SF7BW125",
                    code_rate: "4/5",
                    size: 42,
                    node_id: node.id
                  }

    {:ok, valid_attrs: valid_attrs}
  end

  test "get", %{valid_attrs: valid_attrs} do
    packet = Repo.insert! Packet.changeset(%Packet{}, valid_attrs)
    assert packet == Storage.DB.LoRaWAN.Packet.get(valid_attrs)
  end

  test "create", %{valid_attrs: valid_attrs} do
    {:ok, created} = Storage.DB.LoRaWAN.Packet.create(valid_attrs)
    assert created == Repo.get_by(Packet, number: valid_attrs.number, node_id: valid_attrs.node_id)
  end

  test "update", %{valid_attrs: valid_attrs} do
    packet = Repo.insert! Packet.changeset(%Packet{}, valid_attrs)
    params = %{modulation: "FSK", size: 84}
    {:ok, updated} = Storage.DB.LoRaWAN.Packet.update(%{number: valid_attrs.number, node_id: valid_attrs.node_id}, params)
    assert packet.id == updated.id
    assert packet.modulation != updated.modulation
    assert packet.size != updated.size
  end

  test "delete", %{valid_attrs: valid_attrs} do
    packet = Repo.insert! Packet.changeset(%Packet{}, valid_attrs)
    Storage.DB.LoRaWAN.Packet.delete(valid_attrs)
    refute Repo.get(Packet, packet.id)
  end
end
