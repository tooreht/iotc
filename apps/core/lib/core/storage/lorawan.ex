defmodule Core.Storage.LoRaWAN do
  @doc """
  Storage utilities for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """
  alias Core.Repo
  alias Core.LoRaWAN.Gateway

  import Ecto.Query

  def query_gateway_euis do
    from(g in Gateway, select: g.gw_eui)
    |> Repo.all()
  end

  def lookup_gateway_eui(gateway_eui) do
    gateway_eui in KV.Bucket.get(get_gateway_eui_bucket, "gateway_euis")
  end

  def get_gateway_eui_bucket do
    # Lookup gateway_registry in KV.
    case KV.Registry.lookup(KV.Registry, "gateway_registry") do
      {:ok, bucket} -> bucket
      :error ->
        KV.Registry.create(KV.Registry, "gateway_registry")
        {:ok, bucket} = KV.Registry.lookup(KV.Registry, "gateway_registry")

        # Store gateway_euis in KV.
        KV.Bucket.put(bucket, "gateway_euis", [])
        bucket
    end
  end
end
