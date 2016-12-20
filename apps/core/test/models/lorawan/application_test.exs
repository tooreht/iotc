defmodule Core.LoRaWAN.ApplicationTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Application

  @valid_attrs %{app_eui: "some content", name: "some content", user_id: 1}
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
