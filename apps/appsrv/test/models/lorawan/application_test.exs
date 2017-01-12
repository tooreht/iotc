defmodule AppSrv.LoRaWAN.ApplicationTest do
  use AppSrv.ModelCase

  alias AppSrv.LoRaWAN.Application

  @valid_attrs %{app_eui: "70B3D57ED0000E36", app_root_key: "9056E66E691EC92131DC6A16DB533C42", name: "AlloAllo", user_id: 1}
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
