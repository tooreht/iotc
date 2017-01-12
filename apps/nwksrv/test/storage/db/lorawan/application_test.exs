defmodule NwkSrv.Storage.DB.LoRaWAN.ApplicationTest do
  use NwkSrv.ModelCase

  alias NwkSrv.LoRaWAN.Application
  alias NwkSrv.Storage
  alias NwkSrv.User

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}

    valid_attrs = %{app_eui: "70B3D57ED0000E42", user__email: user.email}

    {:ok, user: user, valid_attrs: valid_attrs}
  end

  test "get", %{user: user, valid_attrs: valid_attrs} do
    application = Repo.insert! %Application{app_eui: "70B3D57ED0000E42", user_id: user.id}
    assert application == Storage.DB.LoRaWAN.Application.get(valid_attrs)
  end

  test "create", %{user: _, valid_attrs: valid_attrs} do
    {:ok, created} = Storage.DB.LoRaWAN.Application.create(valid_attrs)
    assert created == Repo.get_by(Application, app_eui: valid_attrs.app_eui)
  end

  test "update", %{user: user, valid_attrs: _} do
    application = Repo.insert! %Application{app_eui: "70B3D57ED0000E42", user_id: user.id}
    params = %{app_eui: "FFFFFFFFFFFFFFFF", user_id: user.id}
    {:ok, updated} = Storage.DB.LoRaWAN.Application.update(%{app_eui: application.app_eui}, params)
    assert application.id == updated.id
    assert application.app_eui != updated.app_eui
  end

  test "delete", %{user: user, valid_attrs: valid_attrs} do
    application = Repo.insert! %Application{app_eui: "70B3D57ED0000E42", user_id: user.id}
    Storage.DB.LoRaWAN.Application.delete(valid_attrs)
    refute Repo.get(Application, application.id)
  end
end
