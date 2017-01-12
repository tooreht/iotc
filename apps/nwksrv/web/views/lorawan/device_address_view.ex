defmodule NwkSrv.LoRaWAN.DeviceAddressView do
  use NwkSrv.Web, :view

  def render("index.json", %{lorawan_device_addresses: lorawan_device_addresses}) do
    %{data: render_many(lorawan_device_addresses, NwkSrv.LoRaWAN.DeviceAddressView, "device_address.json")}
  end

  def render("show.json", %{device_address: device_address}) do
    %{data: render_one(device_address, NwkSrv.LoRaWAN.DeviceAddressView, "device_address.json")}
  end

  def render("device_address.json", %{device_address: device_address}) do
    %{id: device_address.id,
      dev_addr: device_address.dev_addr,
      last_assigned: device_address.last_assigned}
  end
end
