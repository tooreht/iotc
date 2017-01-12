defmodule NwkSrv.Repo.Migrations.CreateLoRaWAN.DeviceAddress do
  use Ecto.Migration

  def change do
    create table(:lorawan_device_addresses) do
      add :dev_addr, :string
      add :last_assigned, :datetime

      timestamps()
    end
    create unique_index(:lorawan_device_addresses, [:dev_addr])

  end
end
