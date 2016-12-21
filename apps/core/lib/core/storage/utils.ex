defmodule Core.Storage.Utils do
  @doc """
  Storage utilities for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """

  def store_packet(packet) do
    # TODO: Store packets
  end

  def store_packet_meta(packet) do
    # TODO: Store gateway_packets
  end

  # HELPERS

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
    get_or_create_cache("gateway_registry", "stats", [])
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
