defmodule Core.User do
  use Core.Web, :model

  @required_fields ~w(email)
  @optional_fields ~w(username is_active is_superuser)

  schema "users" do
    field :email, :string, null: false
    field :username, :string, null: false
    field :is_active, :boolean, default: false
    field :is_superuser, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:email, :username])
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
  end
end
