defmodule Core.LoRaWAN.Gateway do
  use Core.Web, :model
  alias Core.LoRaWAN.Packet
  alias Core.LoRaWAN.GatewayPacket

  schema "lorawan_gateways" do
    field :gw_eui, :string
    field :ip, :string
    field :last_seen, Ecto.DateTime
    field :adapter, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :altitude, :decimal
    belongs_to :user, Core.User
    many_to_many :lorawan_gateways, Packet, join_through: GatewayPacket

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:gw_eui, :ip, :last_seen, :adapter, :latitude, :longitude, :altitude, :user_id])
    |> validate_required([:gw_eui, :adapter, :user_id])
    |> unique_constraint(:gw_eui)
  end
end
