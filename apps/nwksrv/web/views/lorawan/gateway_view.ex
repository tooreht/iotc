defmodule NwkSrv.LoRaWAN.GatewayView do
  use NwkSrv.Web, :view

  def render("index.json", %{lorawan_gateways: lorawan_gateways}) do
    %{data: render_many(lorawan_gateways, NwkSrv.LoRaWAN.GatewayView, "gateway.json")}
  end

  def render("show.json", %{gateway: gateway}) do
    %{data: render_one(gateway, NwkSrv.LoRaWAN.GatewayView, "gateway.json")}
  end

  def render("gateway.json", %{gateway: gateway}) do
    %{id: gateway.id,
      gw_eui: gateway.gw_eui,
      ip: gateway.ip,
      last_seen: gateway.last_seen,
      adapter: gateway.adapter,
      latitude: gateway.latitude,
      longitude: gateway.longitude,
      altitude: gateway.altitude,
      user_id: gateway.user_id}
  end
end
