defmodule Core.Repo.Migrations.CreateLoRaWAN.GatewayPacket do
  use Ecto.Migration

  def change do
    create table(:gateways_packets) do
      add :time, :integer
      add :rf_chain, :integer
      add :crc_status, :integer
      add :rssi, :integer
      add :snr, :integer
      add :gateway_id, references(:lorawan_gateways, on_delete: :nothing)
      add :packet_id, references(:lorawan_packets, on_delete: :nothing)

      timestamps()
    end
    create index(:gateways_packets, [:gateway_id])
    create index(:gateways_packets, [:packet_id])

  end
end
