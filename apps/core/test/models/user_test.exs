defmodule Core.UserTest do
  use Core.ModelCase

  alias Core.User

  @valid_attrs %{username: "me", email: "me@example.net", is_active: true, is_superuser: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with email too short " do
    changeset = User.changeset(
      %User{}, Map.put(@valid_attrs, :email, "")
    )
    refute changeset.valid?
  end

  test "changeset with invalid email format" do
    changeset = User.changeset(
      %User{}, Map.put(@valid_attrs, :email, "me.net")
    )
    refute changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
