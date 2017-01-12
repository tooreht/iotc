defmodule NwkSrv.Repo.Migrations.CreateLoRaWAN.Gateway.Statistics do
  use Ecto.Migration

  def change do
    create table(:lorawan_gateway_statistics) do
      add :time, :datetime
      add :latitude, :decimal
      add :longitude, :decimal
      add :altitude, :decimal
      add :rx_total, :integer
      add :rx_valid, :integer
      add :rx_forwarded, :integer
      add :tx_received, :integer
      add :tx_emitted, :integer
      add :ack_rate, :float
      add :gateway_id, references(:lorawan_gateways, on_delete: :nothing)

      timestamps()
    end
    create index(:lorawan_gateway_statistics, [:gateway_id])

  end
end
