defmodule Core.Storage.LoRaWAN do
  @doc """
  Storage utilities for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """
  alias Core.Repo
  alias Core.LoRaWAN.Gateway
  alias Core.LoRaWAN.Node

  import Ecto.Query

  def query_gateway_euis do
    from(g in Gateway, select: g.gw_eui)
    |> Repo.all()
  end

  def lookup_gateway_eui(gateway_eui) do
    gateway_eui in KV.Bucket.get(get_gateway_eui_cache, "gateway_euis")
  end

  def store_gateway_meta(gw) do
    if gw.meta do
      # Gateway
      gateway = %Gateway{
        adapter: gw.adapter,
        gw_eui: gw.eui,
        ip: gw.ip,
        last_seen: gw.meta.time,
        latitude: gw.meta.lat,
        longitude: gw.meta.lng,
        altitude: gw.meta.alt
      }
      # Overwrite gateway information with latest data
      KV.Bucket.put(get_gateway_cache, "gateways",
        Map.put(
          KV.Bucket.get(get_gateway_cache, "gateways"),
          gw.eui,
          gateway
        )
      )
      gateway_stat = %Gateway.Statistics{
        ack_rate: gw.meta.ack_rate,
        latitude: gw.meta.lat,
        longitude: gw.meta.lng,
        altitude: gw.meta.alt,
        rx_forwarded: gw.meta.rx.forwarded,
        rx_total: gw.meta.rx.total,
        rx_valid: gw.meta.rx.valid,
        tx_emitted: gw.meta.tx.emitted,
        tx_received: gw.meta.tx.received
      }
      KV.Bucket.put(get_gateway_stats_cache, "stats",
        [gateway_stat | KV.Bucket.get(get_gateway_stats_cache, "stats")]
      )
    end
  end

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
