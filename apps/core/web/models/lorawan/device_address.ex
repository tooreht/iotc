defmodule Core.LoRaWAN.DeviceAddress do
  use Core.Web, :model

  schema "lorawan_device_addresses" do
    field :dev_addr, :string
    field :last_assigned, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:dev_addr, :last_assigned])
    |> validate_required([:dev_addr, :last_assigned])
  end
end
