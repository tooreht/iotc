defmodule Core.LoRaWAN.Node do
  use Core.Web, :model

  schema "lorawan_nodes" do
    field :dev_eui, :string
    field :nwk_s_key, :string
    field :last_seen, Ecto.DateTime
    field :frames_up, :integer
    field :frames_down, :integer
    field :status, :integer
    belongs_to :application, Core.LoRaWAN.Application
    belongs_to :device_address, Core.LoRaWAN.DeviceAddress
    belongs_to :user, Core.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:dev_eui, :nwk_s_key, :last_seen, :frames_up, :frames_down, :status])
    |> validate_required([:dev_eui, :nwk_s_key, :last_seen, :frames_up, :frames_down, :status])
  end
end
