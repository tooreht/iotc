defmodule Core.Storage.DB.LoRaWAN.Gateway do
  @moduledoc """
  CRUD operations for LoRaWAN.Gateway

  - Ecto queries for persistence
  - KV store for caching
  """
  @behaviour Core.Storage

  import Ecto.Query, only: [from: 2]

  alias Core.LoRaWAN.Gateway
  alias Core.Repo
  alias Core.Storage

  #
  # CHANGESET
  #

  def changeset(struct, params \\ %{}) do
    Gateway.changeset(struct, params)
  end

  #
  # GET
  #

  def get(%{gw_eui: gw_eui}) do
    Repo.get_by(Gateway, gw_eui: gw_eui)
  end

  #
  # CREATE
  #

  def create(%{gw_eui: _, adapter: _, user_id: _} = params) do
    get(params) ||
    changeset(%Gateway{}, params)
    |> Repo.insert
  end

  #
  # UPDATE
  #

  def update(%{gw_eui: gw_eui}, params) do
    get(%{gw_eui: gw_eui})
    |> changeset(params)
    |> Repo.update
  end

  #
  # DELETE
  #

  def delete(%{gw_eui: gw_eui}) do
    get(%{gw_eui: gw_eui})
    |> Repo.delete
  end

  #
  # HELPERS
  #

  def query_gateway_euis do
    from(g in Gateway, select: g.gw_eui)
    |> Repo.all()
  end

  def lookup_by_eui(gateway_eui) do
    gateway_eui in KV.Bucket.get(Storage.Utils.get_gateway_eui_cache, "gateway_euis")
  end

  def store_meta(gw) do
    if Map.has_key?(gw, :meta) and gw.meta do
      # Gateway
      gateway = %{
        adapter: gw.adapter,
        gw_eui: gw.eui,
        ip: to_string(:inet_parse.ntoa(gw.ip)),
        last_seen: Timex.parse!(gw.meta.time, "%Y-%m-%d %T %Z", :strftime),
        latitude: gw.meta.lat,
        longitude: gw.meta.lng,
        altitude: gw.meta.alt
      }
      # Overwrite gateway information with latest data
      KV.Bucket.put(Storage.Utils.get_gateway_cache, "gateways",
        Map.put(
          KV.Bucket.get(Storage.Utils.get_gateway_cache, "gateways"),
          gw.eui,
          gateway
        )
      )
      gateway_stats = %{
        ack_rate: gw.meta.ack_rate,
        latitude: gw.meta.lat,
        longitude: gw.meta.lng,
        altitude: gw.meta.alt,
        rx_forwarded: gw.meta.rx.forwarded,
        rx_total: gw.meta.rx.total,
        rx_valid: gw.meta.rx.valid,
        tx_emitted: gw.meta.tx.emitted,
        tx_received: gw.meta.tx.received,
        inserted_at: Ecto.DateTime.utc,
        updated_at: Ecto.DateTime.utc
      }

      # Append gateway statistics to specific gateway
      stats = KV.Bucket.get(Storage.Utils.get_gateway_stats_cache, "stats")
      KV.Bucket.put(Storage.Utils.get_gateway_stats_cache, "stats",
        Map.put(stats, gw.eui, [gateway_stats | Map.get(stats, gw.eui, [])])
      )
    end
  end
end
