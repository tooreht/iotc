defmodule Core.Storage.LoRaWAN.PacketTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Packet
  alias Core.Storage
  alias Core.User

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}
    %{id: application_id} = Core.Storage.LoRaWAN.Application.create(%{
                              app_eui: "70D5B37ED0000E36",
                              user_id: user.id
                            })
    %{id: node_id} = Core.Storage.LoRaWAN.Node.create(%{
                        dev_eui: "2A2B3D4E5F66778A",
                        dev_addr: "00000002",
                        nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
                        application_id: application_id,
                        user_id: user.id
                      })
    valid_attrs = %{
                    type: 3,
                    number: 123,
                    frequency: "868.0",
                    channel: 42,
                    modulation: "LORA" ,
                    data_rate: "SF7BW125",
                    code_rate: "4/5",
                    size: 42,
                    node_id: node_id
                  }

    {:ok, valid_attrs: valid_attrs}
  end

  test "get", %{valid_attrs: valid_attrs} do
    packet = Repo.insert! Packet.changeset(%Packet{}, valid_attrs)
    assert Storage.LoRaWAN.Packet.get(valid_attrs) == packet
  end

  test "create", %{valid_attrs: valid_attrs} do
    assert Storage.LoRaWAN.Packet.create(valid_attrs) == Repo.get_by(Packet, number: valid_attrs.number, node_id: valid_attrs.node_id)
  end

  test "update", %{valid_attrs: valid_attrs} do
    # TODO: Implement
  end

  test "delete", %{valid_attrs: valid_attrs} do
    # packet = Repo.insert! Packet.changeset(%Packet{}, valid_attrs)
    # Storage.LoRaWAN.Packet.delete(valid_attrs)
    # refute Repo.get(Packet, packet.id)
  end
end
