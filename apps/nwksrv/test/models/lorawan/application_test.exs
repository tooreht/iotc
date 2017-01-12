defmodule NwkSrv.LoRaWAN.ApplicationTest do
  use NwkSrv.ModelCase

  alias NwkSrv.LoRaWAN.Application

  @valid_attrs %{app_eui: "70B3D57ED0000E36", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Application.changeset(%Application{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Application.changeset(%Application{}, @invalid_attrs)
    refute changeset.valid?
  end
end
