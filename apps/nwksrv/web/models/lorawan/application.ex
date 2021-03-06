defmodule NwkSrv.LoRaWAN.Application do
  use NwkSrv.Web, :model

  schema "lorawan_applications" do
    field :app_eui, :string
    belongs_to :user, NwkSrv.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:app_eui, :user_id])
    |> validate_required([:app_eui, :user_id])
    |> unique_constraint(:app_eui)
  end
end
