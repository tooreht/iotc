defmodule Core.LoRaWAN.Gateway.Statistics do
  use Core.Web, :model

  schema "lorawan_gateway_statistics" do
    field :latitude, :decimal
    field :longitude, :decimal
    field :altitude, :decimal
    field :rx_total, :integer
    field :rx_valid, :integer
    field :rx_forwarded, :integer
    field :tx_received, :integer
    field :tx_emitted, :integer
    field :ack_rate, :float
    belongs_to :gateway, Core.LoRaWAN.Gateway

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:latitude, :longitude, :altitude, :rx_total, :rx_valid, :rx_forwarded, :tx_received, :tx_emitted, :ack_rate])
    |> validate_required([:latitude, :longitude, :altitude, :rx_total, :rx_valid, :rx_forwarded, :tx_received, :tx_emitted, :ack_rate])
  end
end
