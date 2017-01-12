defmodule NwkSrv.Repo.Migrations.AddDevNonceToPacket do
  use Ecto.Migration

  def change do
    alter table(:lorawan_packets) do
      add :dev_nonce, :string
    end
  end
end
