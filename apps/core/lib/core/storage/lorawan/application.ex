defmodule Core.Storage.LoRaWAN.Application do
  @doc """
  Packet storage for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """
  def create_application(rev_app_eui, name, user_id) do
      app_eui = Base.encode16(String.reverse(rev_app_eui))

      Core.Repo.get_by(Core.LoRaWAN.Application, app_eui: app_eui) ||
      Core.LoRaWAN.Application.changeset(%Core.LoRaWAN.Application{}, %{app_eui: app_eui, name: name, user_id: user_id}) 
      |> Core.Repo.insert!
  end
end
