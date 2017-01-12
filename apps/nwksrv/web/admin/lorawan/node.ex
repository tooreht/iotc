defmodule NwkSrv.ExAdmin.LoRaWAN.Node do
  use ExAdmin.Register

  register_resource NwkSrv.LoRaWAN.Node do
    index do
      selectable_column

      column :id, fn node ->
        raw Phoenix.HTML.Link.link(node.id, to: admin_resource_path(node, :show))
      end
      column :dev_eui
      column :device_address
      column :last_seen
      column :application
      column :user
      actions
    end
  end
end
