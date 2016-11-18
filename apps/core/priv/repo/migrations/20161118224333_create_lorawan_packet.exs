defmodule Core.Repo.Migrations.CreateLoRaWAN.Packet do
  use Ecto.Migration

  def change do
    create table(:lorawan_packets) do
      add :number, :integer
      add :type, :integer
      add :frequency, :decimal
      add :channel, :integer
      add :modulation, :string
      add :data_rate, :string
      add :code_rate, :string
      add :size, :integer
      add :node_id, references(:lorawan_nodes, on_delete: :nothing)

      timestamps()
    end
    create index(:lorawan_packets, [:node_id])

  end
end
