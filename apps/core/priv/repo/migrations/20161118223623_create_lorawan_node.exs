defmodule Core.Repo.Migrations.CreateLoRaWAN.Node do
  use Ecto.Migration

  def change do
    create table(:lorawan_nodes) do
      add :dev_eui, :string
      add :nwk_s_key, :string
      add :last_seen, :datetime
      add :frames_up, :integer, default: 0
      add :frames_down, :integer, default: 0
      add :status, :integer
      add :application_id, references(:lorawan_applications, on_delete: :nothing)
      add :device_address_id, references(:lorawan_device_addresses, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:lorawan_nodes, [:application_id])
    create index(:lorawan_nodes, [:device_address_id])
    create index(:lorawan_nodes, [:user_id])
    create unique_index(:lorawan_nodes, [:dev_eui])

  end
end
