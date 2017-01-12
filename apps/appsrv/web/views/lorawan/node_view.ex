defmodule AppSrv.LoRaWAN.NodeView do
  use AppSrv.Web, :view

  def render("index.json", %{lorawan_nodes: lorawan_nodes}) do
    %{data: render_many(lorawan_nodes, AppSrv.LoRaWAN.NodeView, "node.json")}
  end

  def render("show.json", %{node: node}) do
    %{data: render_one(node, AppSrv.LoRaWAN.NodeView, "node.json")}
  end

  def render("node.json", %{node: node}) do
    %{id: node.id,
      name: node.name,
      dev_eui: node.dev_eui,
      app_key: node.app_key,
      dev_addr: node.dev_addr,
      nwk_s_key: node.nwk_s_key,
      app_s_key: node.app_s_key,
      relax_fcnt: node.relax_fcnt,
      rx_window: node.rx_window,
      rx_delay: node.rx_delay,
      rx1_dr_offset: node.rx1_dr_offset,
      rx2_dr: node.rx2_dr,
      application_id: node.application_id,
      user_id: node.user_id}
  end
end
