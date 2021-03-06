defmodule NwkSrv.Storage.DB.LoRaWAN.NodeTest do
  use NwkSrv.ModelCase

  alias NwkSrv.LoRaWAN.Node
  alias NwkSrv.Storage
  alias NwkSrv.User

  @dev_addr "80D2A146"

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}
    application = Repo.insert! %NwkSrv.LoRaWAN.Application{
                              app_eui: "704FD42E1A0C15C8",
                              user_id: user.id
                            }
    device_address = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: @dev_addr, last_assigned: Ecto.DateTime.utc}

    valid_attrs = %{
                    dev_eui: "AAABAD4E5F6677BB",
                    device_address_id: device_address.id,
                    nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
                    frames_down: 0,
                    frames_up: 0,
                    application__app_eui: application.app_eui,
                    user__email: user.email
                  }

    valid_attrs2 = %{
                    dev_eui: "1B1A2A3D4E556679",
                    device_address_id: device_address.id,
                    nwk_s_key: "44C01B3B2171BAC334123231BA5221DF",
                    frames_down: 0,
                    frames_up: 0,
                    application__app_eui: application.app_eui,
                    user__email: user.email
                  }

    {:ok, user: user, application: application, device_address: device_address, valid_attrs: valid_attrs, valid_attrs2: valid_attrs2}
  end

  test "get", %{user: user, application: application, device_address: device_address, valid_attrs: valid_attrs, valid_attrs2: _} do
    node = Repo.insert! %Node{
      dev_eui: "AAABAD4E5F6677BB",
      device_address_id: device_address.id,
      nwk_s_key: "44C01B3B2171BAC334123231BA5221D0",
      frames_down: 0,
      frames_up: 0,
      application_id: application.id,
      user_id: user.id
    }
    assert Storage.DB.LoRaWAN.Node.get(valid_attrs) == node
  end

  test "create", %{user: user, application: application, device_address: device_address, valid_attrs: valid_attrs, valid_attrs2: _} do
    {:ok, created} = Storage.DB.LoRaWAN.Node.create(valid_attrs)
    assert created == Repo.get_by(Node, dev_eui: valid_attrs.dev_eui)
  end

  test "update", %{user: user, application: application, device_address: device_address, valid_attrs: valid_attrs, valid_attrs2: _} do
    node = Repo.insert! %Node{
      dev_eui: "1B1A2A3D4E556600",
      device_address_id: device_address.id,
      nwk_s_key: "44C01B3B2171BAC334123231BA5221D0",
      frames_down: 0,
      frames_up: 0,
      application_id: application.id,
      user_id: user.id
    }
    params = %{dev_eui: "FFFFFFFFFFFFFFFF", user__email: user.email}
    {:ok, updated} = Storage.DB.LoRaWAN.Node.update(%{dev_eui: node.dev_eui}, params)
    assert node.id == updated.id
    assert node.dev_eui != updated.dev_eui
  end

  test "delete", %{user: user, application: application, device_address: device_address, valid_attrs: valid_attrs, valid_attrs2: _} do
    node = Repo.insert! %Node{
      dev_eui: "AAABAD4E5F6677BB",
      device_address_id: device_address.id,
      nwk_s_key: "44C01B3B2171BAC334123231BA5221D0",
      frames_down: 0,
      frames_up: 0,
      application_id: application.id,
      user_id: user.id
    }
    Storage.DB.LoRaWAN.Node.delete(valid_attrs)
    refute Repo.get(Node, node.id)
  end

  test "multi-get", %{user: user, application: application, device_address: device_address, valid_attrs: valid_attrs, valid_attrs2: valid_attrs2} do
    Repo.insert! %Node{
      dev_eui: "AAABAD4E5F6677BB",
      device_address_id: device_address.id,
      nwk_s_key: "44C01B3B2171BAC334123231BA5221D0",
      frames_down: 0,
      frames_up: 0,
      application_id: application.id,
      user_id: user.id
    }
    Repo.insert! %Node{
      dev_eui: "1B1A2A3D4E556679",
      device_address_id: device_address.id,
      nwk_s_key: "44C01B3B2171BAC334123231BA5221D1",
      frames_down: 0,
      frames_up: 0,
      application_id: application.id,
      user_id: user.id
    }
    [node1, node2] = Storage.DB.LoRaWAN.Node.get_nodes(%{dev_addr: @dev_addr, f_cnt: 0})
    assert Storage.DB.LoRaWAN.Node.get(valid_attrs) == node2
    assert Storage.DB.LoRaWAN.Node.get(valid_attrs2) == node1
  end
end
