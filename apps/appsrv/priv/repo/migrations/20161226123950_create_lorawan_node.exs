defmodule AppSrv.Repo.Migrations.CreateLoRaWAN.Node do
  use Ecto.Migration

  def change do
    create table(:lorawan_nodes) do
      add :name, :string
      add :dev_eui, :string
      add :dev_addr, :string
      add :app_key, :string
      add :app_s_key, :string
      add :nwk_s_key, :string
      add :relax_fcnt, :boolean, default: false, null: false
      add :rx_window, :integer
      add :rx_delay, :integer
      add :rx1_dr_offset, :integer
      add :rx2_dr, :integer
      add :application_id, references(:lorawan_applications, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:lorawan_nodes, [:application_id])
    create index(:lorawan_nodes, [:user_id])
    create unique_index(:lorawan_nodes, [:dev_eui])

  end
end
