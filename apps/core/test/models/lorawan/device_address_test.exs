defmodule Core.LoRaWAN.DeviceAddressTest do
  use Core.ModelCase

  alias Core.LoRaWAN.DeviceAddress

  @valid_attrs %{dev_addr: "1CF3BA77", last_assigned: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DeviceAddress.changeset(%DeviceAddress{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DeviceAddress.changeset(%DeviceAddress{}, @invalid_attrs)
    refute changeset.valid?
  end
end
