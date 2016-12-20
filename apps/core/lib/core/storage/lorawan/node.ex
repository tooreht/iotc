defmodule Core.Storage.LoRaWAN.Node do
  @doc """
  Node storage for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """
  
  def create_node(rev_dev_eui, rev_dev_addr, rev_nwk_s_key, user_id) do
    dev_eui = Base.encode16(String.reverse(rev_dev_eui))
    dev_addr = Base.encode16(String.reverse(rev_dev_addr))
    nwk_s_key = Base.encode16(String.reverse(rev_nwk_s_key))

    %{id: dev_addr_id}  = Core.Repo.get_by(Core.LoRaWAN.DeviceAddress, dev_addr: dev_addr) ||
      Core.LoRaWAN.DeviceAddress.changeset(%Core.LoRaWAN.DeviceAddress{}, %{dev_addr: dev_addr, last_assigned: Ecto.DateTime.utc}) 
      |> Core.Repo.insert!

    node = Core.Repo.get_by(Core.LoRaWAN.Node, dev_eui: dev_eui) ||
      Core.LoRaWAN.Node.changeset(%Core.LoRaWAN.Node{}, %{dev_eui: dev_eui, nwk_s_key:  nwk_s_key, device_address_id: dev_addr_id, user_id: user_id})
      |> Core.Repo.insert!

    node
  end
  
end
