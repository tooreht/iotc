defmodule NwkSrv.Storage.DB.LoRaWAN.GatewayTest do
  use NwkSrv.ModelCase

  alias NwkSrv.LoRaWAN.Gateway
  alias NwkSrv.Storage
  alias NwkSrv.User

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}

    valid_attrs = %{
      gw_eui: "B827EBFFFE7B80CD",
      adapter: "Semtech",
      ip: "10.0.0.11",
      last_seen: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
      latitude: "120.5",
      longitude: "120.5",
      altitude: "120.5",
      user_id: user.id
    }

    {:ok, valid_attrs: valid_attrs}
  end

  test "get", %{valid_attrs: valid_attrs} do
    application = Repo.insert! Gateway.changeset(%Gateway{}, valid_attrs)
    assert application == Storage.DB.LoRaWAN.Gateway.get(valid_attrs)
  end

  test "create", %{valid_attrs: valid_attrs} do
    {:ok, created} = Storage.DB.LoRaWAN.Gateway.create(valid_attrs)
    assert created == Repo.get_by(Gateway, gw_eui: valid_attrs.gw_eui)
  end

  test "update", %{valid_attrs: valid_attrs} do
    application = Repo.insert! Gateway.changeset(%Gateway{}, valid_attrs)
    params = %{gw_eui: "FFFFFFFFFFFFFFFF", user_id: valid_attrs.user_id}
    {:ok, updated} = Storage.DB.LoRaWAN.Gateway.update(%{gw_eui: application.gw_eui}, params)
    assert application.id == updated.id
    assert application.gw_eui != updated.gw_eui
  end

  test "delete", %{valid_attrs: valid_attrs} do
    application = Repo.insert! Gateway.changeset(%Gateway{}, valid_attrs)
    Storage.DB.LoRaWAN.Gateway.delete(valid_attrs)
    refute Repo.get(Gateway, application.id)
  end
end
