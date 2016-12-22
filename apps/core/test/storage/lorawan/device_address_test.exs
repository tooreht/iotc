defmodule Core.Storage.LoRaWAN.DeviceAddressTest do
  use Core.ModelCase

  alias Core.LoRaWAN.DeviceAddress
  alias Core.Storage

  setup do

    valid_attrs = %{
      dev_addr: "972D1A64",
      last_assigned: %{day: 14, hour: 11, min: 5, month: 3, sec: 10, year: 2016},
    }

    {:ok, valid_attrs: valid_attrs}
  end

  test "get", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    assert Storage.LoRaWAN.DeviceAddress.get(valid_attrs) == device_address
  end

  test "get with reverse dev_addr", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    assert Storage.LoRaWAN.DeviceAddress.get(%{rev_dev_addr: String.reverse(valid_attrs.dev_addr) |> Base.decode16!}) == device_address
  end

  test "create", %{valid_attrs: valid_attrs} do
    assert Storage.LoRaWAN.DeviceAddress.create(valid_attrs) == Repo.get_by(DeviceAddress, dev_addr: valid_attrs.dev_addr)
  end

  test "create with reverse dev_addr", %{valid_attrs: valid_attrs} do
    attrs = %{rev_dev_addr: String.reverse(valid_attrs.dev_addr) |> Base.decode16!}
    assert Storage.LoRaWAN.DeviceAddress.create(attrs) == Repo.get_by(DeviceAddress, dev_addr: valid_attrs.dev_addr)
  end

  test "update", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    params = %{dev_addr: "FFFFFFFF"}
    {:ok, updated} = Storage.LoRaWAN.DeviceAddress.update(%{dev_addr: device_address.dev_addr}, params)
    assert device_address.id == updated.id
    assert device_address.dev_addr != updated.dev_addr
  end

  test "update with reverse dev_addr", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    rev_dev_addr = String.reverse(valid_attrs.dev_addr) |> Base.decode16!
    params = %{rev_dev_addr: String.reverse("FFFFFFFF") |> Base.decode16!}
    {:ok, updated} = Storage.LoRaWAN.DeviceAddress.update(%{rev_dev_addr: rev_dev_addr}, params)
    assert device_address.id == updated.id
    assert device_address.dev_addr != updated.dev_addr
  end

  test "delete", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    Storage.LoRaWAN.DeviceAddress.delete(valid_attrs)
    refute Repo.get(DeviceAddress, device_address.id)
  end

  test "delete with reverse dev_addr", %{valid_attrs: valid_attrs} do
    device_address = Repo.insert! DeviceAddress.changeset(%DeviceAddress{}, valid_attrs)
    Storage.LoRaWAN.DeviceAddress.delete(%{rev_dev_addr: String.reverse(valid_attrs.dev_addr) |> Base.decode16!})
    refute Repo.get(DeviceAddress, device_address.id)
  end
end
