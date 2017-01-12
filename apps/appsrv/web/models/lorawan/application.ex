defmodule AppSrv.LoRaWAN.Application do
  use AppSrv.Web, :model

  schema "lorawan_applications" do
    field :name, :string
    field :app_eui, :string
    field :app_root_key, :string
    belongs_to :user, AppSrv.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :app_eui, :app_root_key, :user_id])
    |> validate_required([:name, :app_eui, :user_id]) # TODO: Autogenerate app_eui if empty
    |> validate_format(:app_eui, ~r/[a-fA-F0-9]{16}/) # 64bit HEX string
    |> validate_format(:app_root_key, ~r/[a-fA-F0-9]{32}/) # 128bit HEX string
    |> unique_constraint(:app_eui)
  end
end
