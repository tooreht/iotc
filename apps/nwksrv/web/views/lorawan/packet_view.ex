defmodule NwkSrv.LoRaWAN.PacketView do
  use NwkSrv.Web, :view

  def render("index.json", %{lorawan_packets: lorawan_packets}) do
    %{data: render_many(lorawan_packets, NwkSrv.LoRaWAN.PacketView, "packet.json")}
  end

  def render("show.json", %{packet: packet}) do
    %{data: render_one(packet, NwkSrv.LoRaWAN.PacketView, "packet.json")}
  end

  def render("packet.json", %{packet: packet}) do
    %{id: packet.id,
      number: packet.number,
      dev_nonce: packet.dev_nonce,
      type: packet.type,
      frequency: packet.frequency,
      channel: packet.channel,
      modulation: packet.modulation,
      data_rate: packet.data_rate,
      code_rate: packet.code_rate,
      size: packet.size,
      node_id: packet.node_id}
  end
end
