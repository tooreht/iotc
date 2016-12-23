defmodule Core.Storage.LoRaWAN.NodeTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Node
  alias Core.Storage
  alias Core.User

  @dev_addr "80D2A146"

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}
    %{id: application_id} = Core.Storage.LoRaWAN.Application.create(%{
                              app_eui: "70B3D57ED0000E42",
                              user_id: user.id
                            })

    %{id: dev_addr_id} = Core.Storage.LoRaWAN.DeviceAddress.create(%{dev_addr: @dev_addr})

    valid_attrs = %{
                    dev_eui: "AAABAD4E5F6677BB",
                    device_address_id: dev_addr_id,
                    nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
                    frames_down: 0,
                    frames_up: 0,
                    application_id: application_id,
                    frames_down: 0,
                    frames_up: 0,
                    user_id: user.id
                  }

    valid_attrs2 = %{
                    dev_eui: "1B1A2A3D4E556679",
                    device_address_id: dev_addr_id,
                    nwk_s_key: "44C01B3B2171BAC334123231BA5221DF",
                    application_id: application_id,
                    frames_down: 0,
                    frames_up: 0,
                    user_id: user.id
                  }

    {:ok, valid_attrs: valid_attrs, valid_attrs2: valid_attrs2}
  end

  test "get", %{valid_attrs: valid_attrs, valid_attrs2: _} do
    node = Repo.insert! Node.changeset(%Node{}, valid_attrs)
    assert Storage.LoRaWAN.Node.get(valid_attrs) == node
  end

  test "create", %{valid_attrs: valid_attrs, valid_attrs2: _} do
    assert Storage.LoRaWAN.Node.create(valid_attrs) == Repo.get_by(Node, dev_eui: valid_attrs.dev_eui)
  end

  test "update", %{valid_attrs: valid_attrs, valid_attrs2: _} do
    node = Repo.insert! Node.changeset(%Node{}, valid_attrs)
    params = %{dev_eui: "FFFFFFFFFFFFFFFF", user_id: valid_attrs.user_id}
    {:ok, updated} = Storage.LoRaWAN.Node.update(%{dev_eui: node.dev_eui}, params)
    assert node.id == updated.id
    assert node.dev_eui != updated.dev_eui
  end

  test "delete", %{valid_attrs: valid_attrs, valid_attrs2: _} do
    node = Repo.insert! Node.changeset(%Node{}, valid_attrs)
    Storage.LoRaWAN.Node.delete(valid_attrs)
    refute Repo.get(Node, node.id)
  end

  test "multi-get", %{valid_attrs: valid_attrs, valid_attrs2: valid_attrs2} do
    Repo.insert! Node.changeset(%Node{}, valid_attrs)
    Repo.insert! Node.changeset(%Node{}, valid_attrs2)
    [node1, node2] = Storage.LoRaWAN.Node.get_nodes(%{dev_addr: @dev_addr, f_cnt: 0})
    assert Storage.LoRaWAN.Node.get(valid_attrs) == node2
    assert Storage.LoRaWAN.Node.get(valid_attrs2) == node1
  end
end
