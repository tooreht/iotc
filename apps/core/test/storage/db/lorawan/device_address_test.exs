defmodule Core.Storage.DB.LoRaWAN.DeviceAddressTest do
  use Core.ModelCase

  alias Core.LoRaWAN.DeviceAddress
  alias Core.Storage

  setup do

    valid_attrs = %{
      dev_addr: "79D2A146",
      last_assigned: %{day: 14, hour: 11, min: 5, month: 3, sec: 10, year: 2016},
    }

    {:ok, valid_attrs: valid_attrs}
  end

  test "get", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    assert Storage.DB.LoRaWAN.DeviceAddress.get(valid_attrs) == device_address
  end

  test "create", %{valid_attrs: valid_attrs} do
    {:ok, created} = Storage.DB.LoRaWAN.DeviceAddress.create(valid_attrs)
    assert created == Repo.get_by(DeviceAddress, dev_addr: valid_attrs.dev_addr)
  end

  test "update", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    params = %{dev_addr: "FFFFFFFF"}
    {:ok, updated} = Storage.DB.LoRaWAN.DeviceAddress.update(%{dev_addr: device_address.dev_addr}, params)
    assert device_address.id == updated.id
    assert device_address.dev_addr != updated.dev_addr
  end

  test "delete", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    Storage.DB.LoRaWAN.DeviceAddress.delete(valid_attrs)
    refute Repo.get(DeviceAddress, device_address.id)
  end
end
