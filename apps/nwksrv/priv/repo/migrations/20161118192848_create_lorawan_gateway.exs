defmodule NwkSrv.Repo.Migrations.CreateLoRaWAN.Gateway do
  use Ecto.Migration

  def change do
    create table(:lorawan_gateways) do
      add :gw_eui, :string
      add :ip, :string
      add :last_seen, :datetime
      add :adapter, :string
      add :latitude, :decimal
      add :longitude, :decimal
      add :altitude, :decimal
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:lorawan_gateways, [:user_id])
    create unique_index(:lorawan_gateways, [:gw_eui])

  end
end
