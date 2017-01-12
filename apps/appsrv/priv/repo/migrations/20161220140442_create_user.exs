defmodule AppSrv.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :username, :string
      add :is_active, :boolean, default: false, null: false
      add :is_superuser, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
