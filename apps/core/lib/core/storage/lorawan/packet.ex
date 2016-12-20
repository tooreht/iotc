defmodule Core.Storage.LoRaWAN.Packet do
  @doc """
  Packet storage for LoRaWAN

  - Ecto queries for persistence
  - KV store for caching
  """
    def exists_data_packet?(number, node_id) do
      if Core.Repo.get_by(Core.LoRaWAN.Packet, number: number, node_id: node_id) do
        true
      else
        false
      end
    end

    def create_data_packet(type, number, frequency, channel, modulation, data_rate, code_rate, size, node_id) do
      Core.Repo.get_by(Core.LoRaWAN.Packet, number: number, node_id: node_id) ||
      Core.LoRaWAN.Packet.changeset(%Core.LoRaWAN.Packet{}, %{number: number, type: type, frequency: frequency, channel: channel, modulation: modulation, data_rate: data_rate, code_rate: code_rate, size: size, node_id: node_id}) 
      |> Core.Repo.insert!
  end

end
