defmodule AppSrv.Repo.Migrations.CreateLoRaWAN.Application do
  use Ecto.Migration

  def change do
    create table(:lorawan_applications) do
      add :name, :string
      add :app_eui, :string
      add :app_root_key, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:lorawan_applications, [:user_id])
    create unique_index(:lorawan_applications, [:app_eui])

  end
end
