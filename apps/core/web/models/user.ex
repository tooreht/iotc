defmodule Core.User do
  use Core.Web, :model
  use Coherence.Schema

  schema "users" do
    field :email, :string, null: false
    field :username, :string, null: false
    field :is_active, :boolean, default: false
    field :is_superuser, :boolean, default: false

    # handled by coherence
    # field :password_hash, :string
    # field :password, :string, virtual: true
    # field :password_confirmation, :string, virtual: true

    coherence_schema

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(username email) ++ coherence_fields)
    |> validate_required([:email, :username])
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
    |> validate_coherence(params)
  end
end
