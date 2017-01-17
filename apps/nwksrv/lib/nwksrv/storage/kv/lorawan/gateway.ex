defmodule NwkSrv.Storage.KV.LoRaWAN.Gateway do
  @moduledoc """
  KV store operations for caching
  """
  alias NwkSrv.Storage

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
        time: Timex.parse!(gw.meta.time, "%Y-%m-%d %T %Z", :strftime) |> Timex.to_erlang_datetime |> Ecto.DateTime.from_erl,
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
