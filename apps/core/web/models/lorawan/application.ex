defmodule Core.LoRaWAN.Application do
  use Core.Web, :model

  schema "lorawan_applications" do
    field :app_eui, :string
    field :name, :string
    belongs_to :user, Core.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:app_eui, :name])
    |> validate_required([:app_eui, :name])
  end
end
