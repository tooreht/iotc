defmodule Core.Storage.LoRaWAN.PacketTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Packet
  alias Core.Storage
  alias Core.User

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}
    %{id: application_id} = Core.Storage.LoRaWAN.Application.create(%{
                              rev_app_eui: <<200, 21, 12, 26, 46, 212, 79, 112>>,
                              user_id: user.id
                            })
    %{id: node_id} = Core.Storage.LoRaWAN.Node.create(%{
                        rev_dev_eui: <<138, 119, 102, 95, 78, 61, 43, 42>>,
                        rev_dev_addr: <<2, 0, 0, 0>>,
                        rev_nwk_s_key: <<98, 122, 185, 83, 49, 33, 35, 132, 193, 203, 116, 81, 74, 14, 201, 84>>,
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
