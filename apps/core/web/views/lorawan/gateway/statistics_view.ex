defmodule Core.LoRaWAN.Gateway.StatisticsView do
  use Core.Web, :view

  def render("index.json", %{lorawan_gateway_statistics: lorawan_gateway_statistics}) do
    %{data: render_many(lorawan_gateway_statistics, Core.LoRaWAN.Gateway.StatisticsView, "statistics.json")}
  end

  def render("show.json", %{statistics: statistics}) do
    %{data: render_one(statistics, Core.LoRaWAN.Gateway.StatisticsView, "statistics.json")}
  end

  def render("statistics.json", %{statistics: statistics}) do
    %{id: statistics.id,
      latitude: statistics.latitude,
      longitude: statistics.longitude,
      altitude: statistics.altitude,
      rx_total: statistics.rx_total,
      rx_valid: statistics.rx_valid,
      rx_forwarded: statistics.rx_forwarded,
      tx_received: statistics.tx_received,
      tx_emitted: statistics.tx_emitted,
      ack_rate: statistics.ack_rate,
      gateway_id: statistics.gateway_id}
  end
end
