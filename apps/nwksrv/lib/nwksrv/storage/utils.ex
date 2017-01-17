defmodule NwkSrv.Storage.Utils do
  @doc """
  Storage utilities for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """
  require Logger

  def get_nodes(rev_dev_addr, f_cnt) do
    dev_addr = rev_bytes_to_base16(rev_dev_addr)
    nodes = NwkSrv.Storage.DB.LoRaWAN.Node.get_nodes(%{dev_addr: dev_addr, f_cnt: f_cnt})
    if nodes == [] do
      Logger.warn "no device with dev_addr " <> inspect(dev_addr) <> " found!"
      nodes
    else
      nodes
    end
  end

  def get_app_key(app_eui, dev_eui) do
    # TODO: Delegate DB lookup of app_key to AppSrv
    case {app_eui, dev_eui} do
      {<<54, 14, 0, 208, 126, 213, 179, 112>>, <<139, 119, 102, 95, 78, 61, 43, 42>>} ->
        <<191, 185, 219, 229, 78, 139, 209, 131, 24, 59, 112, 168, 106, 103, 175, 73>>
      _ ->
        Logger.warn "No combination of AppEUI + DevEUI found -> no AppKey Found!"
        <<0x00000000000000000000000000000000::128>>
    end
  end

  def insert_existing_device(dev_eui, dev_addr, nw_key) do
    # Insert Device 1 <<70, 161, 210, 121>>
    device_addr = NwkSrv.Repo.get_by(NwkSrv.LoRaWAN.DeviceAddress, dev_addr: Base.encode16(dev_addr))
    %{id: dev_addr_id} = if device_addr do
      device_addr
    else
      NwkSrv.LoRaWAN.DeviceAddress.changeset(%NwkSrv.LoRaWAN.DeviceAddress{}, %{dev_addr: Base.encode16(dev_addr), last_assigned: Ecto.DateTime.utc}) # TODO: change milli_seconds to milliseconds when upgrading to elrang 19
      |> NwkSrv.Repo.insert!
    end

    device = NwkSrv.Repo.get_by(NwkSrv.LoRaWAN.Node, dev_eui: Base.encode16(dev_eui))
    %{id: dev_id} = if device do
      device
    else
      NwkSrv.LoRaWAN.Node.changeset(%NwkSrv.LoRaWAN.Node{}, %{dev_eui: Base.encode16(dev_eui), nw_key:  Base.encode16(nw_key), device_address_id: dev_addr_id})
      |> NwkSrv.Repo.insert!
    end
  end

  def store_packet(packet) do
    # TODO: Store packets
  end

  def store_packet_meta(packet) do
    # TODO: Store gateway_packets
  end


  # LORAWAN HELPERS

  def reverse_bytes(bytes) do
    bytes
    |> :erlang.bitstring_to_list
    |> Enum.reverse
    |> :erlang.list_to_bitstring
  end

  def rev_bytes_to_base16(bytes) do
    bytes
    |> reverse_bytes
    |> Base.encode16
  end

  def rev_bytes_from_base16(base16) do
    base16
    |> Base.decode16!
    |> reverse_bytes
  end


  # CACHE HELPERS

  def get_packet_cache do
    get_or_create_cache("packet_registry", "packets", %{})
  end

  def get_gateway_packet_cache do
    get_or_create_cache("packet_registry", "gateway_packets", [])
  end

  def get_node_cache do
    get_or_create_cache("node_registry", "nodes", %{})
  end

  def get_gateway_cache do
    get_or_create_cache("gateway_registry", "gateways", %{})
  end

  def get_gateway_stats_cache do
    get_or_create_cache("gateway_registry", "stats", %{})
  end

  def get_gateway_eui_cache do
    get_or_create_cache("gateway_registry", "gateway_euis", [])
  end

  # PRIVATE FUNCTIONS

  defp get_or_create_cache(registry_name, bucket_name, initial_value) do
    # Lookup registry_name in KV.
    bucket = case KV.Registry.lookup(KV.Registry, registry_name) do
      {:ok, bucket} -> bucket
      :error ->
        KV.Registry.create(KV.Registry, registry_name)
        {:ok, bucket} = KV.Registry.lookup(KV.Registry, registry_name)
        bucket
    end

    if KV.Bucket.get(bucket, bucket_name) == nil do
      # Initialize bucket in KV.
      KV.Bucket.put(bucket, bucket_name, initial_value)
    end
    bucket
  end
end
