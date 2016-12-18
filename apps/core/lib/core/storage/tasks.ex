defmodule Core.Storage.Tasks do
  @moduledoc """
  Storage related tasks.
  """
  alias Core.Storage

  @doc """
  Fetch list of registered gateway ids from db and update bucket.
  """
  def refresh_gateway_euis_from_db do
    KV.Bucket.put(Storage.LoRaWAN.get_gateway_eui_bucket, "gateway_euis", Storage.LoRaWAN.query_gateway_euis)
  end
end
