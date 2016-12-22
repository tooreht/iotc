defmodule Core.Storage.LoRaWAN.ApplicationTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Application
  alias Core.Storage
  alias Core.Storage.Utils
  alias Core.User

  setup do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}

    valid_attrs = %{app_eui: "70B3D57ED0000E42", user_id: user.id}

    {:ok, valid_attrs: valid_attrs}
  end

  test "get", %{valid_attrs: valid_attrs} do
    application = Repo.insert! Application.changeset(%Application{}, valid_attrs)
    assert Storage.LoRaWAN.Application.get(valid_attrs) == application
  end

  test "create", %{valid_attrs: valid_attrs} do
    assert Storage.LoRaWAN.Application.create(valid_attrs) == Repo.get_by(Application, app_eui: valid_attrs.app_eui)
  end

  test "update", %{valid_attrs: valid_attrs} do
    application = Repo.insert! Application.changeset(%Application{}, valid_attrs)
    params = %{app_eui: "FFFFFFFFFFFFFFFF", user_id: valid_attrs.user_id}
    {:ok, updated} = Storage.LoRaWAN.Application.update(%{app_eui: application.app_eui}, params)
    assert application.id == updated.id
    assert application.app_eui != updated.app_eui
  end

  test "delete", %{valid_attrs: valid_attrs} do
    application = Repo.insert! Application.changeset(%Application{}, valid_attrs)
    Storage.LoRaWAN.Application.delete(valid_attrs)
    refute Repo.get(Application, application.id)
  end
end
