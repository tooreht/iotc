defmodule Core.Storage.LoRaWAN.NodeTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Node
  alias Core.Storage
  alias Core.User

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}
    %{id: application_id} = Core.Storage.LoRaWAN.Application.create(%{
                              app_eui: "70B3D57ED0000E42",
                              user_id: user.id
                            })
    valid_attrs = %{
                    dev_eui: "2A2B3D4E5F66778A",
                    dev_addr: "1CF3BA77",
                    nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
                    frames_down: 0,
                    frames_up: 0,
                    application_id: application_id,
                    user_id: user.id
                  }

    {:ok, valid_attrs: valid_attrs}
  end

  test "get", %{valid_attrs: valid_attrs} do
    node = Repo.insert! Node.changeset(%Node{}, valid_attrs)
    assert Storage.LoRaWAN.Node.get(valid_attrs) == node
  end

  test "create", %{valid_attrs: valid_attrs} do
    assert Storage.LoRaWAN.Node.create(valid_attrs) == Repo.get_by(Node, dev_eui: valid_attrs.dev_eui)
  end

  test "update", %{valid_attrs: valid_attrs} do
    node = Repo.insert! Node.changeset(%Node{}, valid_attrs)
    params = %{dev_eui: "FFFFFFFFFFFFFFFF", user_id: valid_attrs.user_id}
    {:ok, updated} = Storage.LoRaWAN.Node.update(%{dev_eui: node.dev_eui}, params)
    assert node.id == updated.id
    assert node.dev_eui != updated.dev_eui
  end

  test "delete", %{valid_attrs: valid_attrs} do
    node = Repo.insert! Node.changeset(%Node{}, valid_attrs)
    Storage.LoRaWAN.Node.delete(valid_attrs)
    refute Repo.get(Node, node.id)
  end
end
