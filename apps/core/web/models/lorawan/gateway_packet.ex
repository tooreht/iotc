defmodule Core.LoRaWAN.GatewayPacket do
  use Core.Web, :model

  schema "gateways_packets" do
    field :time, :integer
    field :rf_chain, :integer
    field :crc_status, :integer
    field :rssi, :integer
    field :snr, :integer
    belongs_to :gateway, Core.LoRaWAN.Gateway
    belongs_to :packet, Core.LoRaWAN.Packet

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:time, :rf_chain, :crc_status, :rssi, :snr])
    |> validate_required([:time, :rf_chain, :crc_status, :rssi, :snr])
  end
end
