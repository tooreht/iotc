defmodule Core.LoRaWAN.Packet do
  use Core.Web, :model
  alias Core.LoRaWAN.Gateway
  alias Core.LoRaWAN.GatewayPacket

  schema "lorawan_packets" do
    field :number, :integer
    field :type, :integer
    field :frequency, :decimal
    field :channel, :integer
    field :modulation, :string
    field :data_rate, :string
    field :code_rate, :string
    field :size, :integer
    belongs_to :node, Core.LoRaWAN.Node

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number, :type, :frequency, :channel, :modulation, :data_rate, :code_rate, :size])
    |> validate_required([:number, :type, :frequency, :channel, :modulation, :data_rate, :code_rate, :size])
  end
end
