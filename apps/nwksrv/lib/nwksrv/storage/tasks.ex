defmodule NwkSrv.Storage.Tasks do
  @moduledoc """
  Storage related tasks.
  """
  alias NwkSrv.LoRaWAN.Gateway
  alias NwkSrv.Repo
  alias NwkSrv.Storage

  @doc """
  Fetch list of registered gateway ids from db and update bucket.
  """
  def refresh_gateway_euis_from_db do
    KV.Bucket.put(Storage.Utils.get_gateway_eui_cache, "gateway_euis", Storage.DB.LoRaWAN.Gateway.query_gateway_euis)
  end

  @doc """
  Persist cached gateway data in bucket to db.
  """
  def persist_gateways_to_db do
    stats = KV.Bucket.get(Storage.Utils.get_gateway_stats_cache, "stats")
    for {eui, gw} <- KV.Bucket.get(Storage.Utils.get_gateway_cache, "gateways") do
      gateway = Repo.get_by(Gateway, gw_eui: eui)
      Repo.update!(Gateway.changeset(gateway, gw))
      Repo.insert_all(Gateway.Statistics, Enum.map(Map.get(stats, eui), &Map.put(&1, :gateway_id, gateway.id)))
    end
    KV.Bucket.put(Storage.Utils.get_gateway_cache, "gateways", %{})
    KV.Bucket.put(Storage.Utils.get_gateway_stats_cache, "stats", %{})
  end
end
