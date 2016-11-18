defmodule Core.LoRaWAN.NodeView do
  use Core.Web, :view

  def render("index.json", %{lorawan_nodes: lorawan_nodes}) do
    %{data: render_many(lorawan_nodes, Core.LoRaWAN.NodeView, "node.json")}
  end

  def render("show.json", %{node: node}) do
    %{data: render_one(node, Core.LoRaWAN.NodeView, "node.json")}
  end

  def render("node.json", %{node: node}) do
    %{id: node.id,
      dev_eui: node.dev_eui,
      device_address_id: node.device_address_id,
      application_id: node.application_id,
      nwk_s_key: node.nwk_s_key,
      last_seen: node.last_seen,
      frames_up: node.frames_up,
      frames_down: node.frames_down,
      status: node.status,
      user_id: node.user_id}
  end
end
