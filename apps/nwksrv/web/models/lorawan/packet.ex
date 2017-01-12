defmodule NwkSrv.LoRaWAN.Packet do
  use NwkSrv.Web, :model

  schema "lorawan_packets" do
    field :number, :integer
    field :dev_nonce, :string
    field :type, :integer
    field :frequency, :decimal
    field :channel, :integer
    field :modulation, :string
    field :data_rate, :string
    field :code_rate, :string
    field :size, :integer
    belongs_to :node, NwkSrv.LoRaWAN.Node

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number, :dev_nonce, :type, :frequency, :channel, :modulation, :data_rate, :code_rate, :size, :node_id])
    |> validate_required([:type, :frequency, :channel, :modulation, :data_rate, :code_rate, :size, :node_id])
  end
end
