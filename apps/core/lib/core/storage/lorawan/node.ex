defmodule Core.Storage.LoRaWAN.Node do
  @doc """
  Node storage for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """
  
  def create_node(rev_dev_eui, rev_dev_addr, rev_nw_key, application_id, user_id) do
    dev_eui = Base.encode16(String.reverse(rev_dev_eui))
    dev_addr = Base.encode16(String.reverse(rev_dev_addr))
    nw_key = Base.encode16(String.reverse(rev_nw_key))

    %{id: dev_addr_id}  = Core.Repo.get_by(Core.LoRaWAN.DeviceAddress, dev_addr: dev_addr) ||
      Core.LoRaWAN.DeviceAddress.changeset(%Core.LoRaWAN.DeviceAddress{}, %{dev_addr: dev_addr, last_assigned: Ecto.DateTime.utc}) 
      |> Core.Repo.insert!

    node = Core.Repo.get_by(Core.LoRaWAN.Node, dev_eui: dev_eui) ||
      Core.LoRaWAN.Node.changeset(%Core.LoRaWAN.Node{}, %{dev_eui: dev_eui, nw_key:  nw_key, device_address_id: dev_addr_id, application_id: application_id, user_id: user_id})
      |> Core.Repo.insert!

    node
  end

  def get_notes_by_dev_addr(dev_addr) do
    
  end
  
end
