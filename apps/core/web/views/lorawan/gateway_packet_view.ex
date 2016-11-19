defmodule Core.LoRaWAN.GatewayPacketView do
  use Core.Web, :view

  def render("index.json", %{gateways_packets: gateways_packets}) do
    %{data: render_many(gateways_packets, Core.LoRaWAN.GatewayPacketView, "gateway_packet.json")}
  end

  def render("show.json", %{gateway_packet: gateway_packet}) do
    %{data: render_one(gateway_packet, Core.LoRaWAN.GatewayPacketView, "gateway_packet.json")}
  end

  def render("gateway_packet.json", %{gateway_packet: gateway_packet}) do
    %{id: gateway_packet.id,
      gateway_id: gateway_packet.gateway_id,
      packet_id: gateway_packet.packet_id,
      time: gateway_packet.time,
      rf_chain: gateway_packet.rf_chain,
      crc_status: gateway_packet.crc_status,
      rssi: gateway_packet.rssi,
      snr: gateway_packet.snr}
  end
end
