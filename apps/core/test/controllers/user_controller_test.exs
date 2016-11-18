defmodule Core.UserControllerTest do
  use Core.ConnCase

  alias Core.User
  @valid_attrs %{name: "Me", email: "me@example.net", username: "me"}
  @invalid_attrs %{email: "me.example.net"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! Map.merge(%User{}, @valid_attrs)
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{
      "id" => user.id,
      "name" => user.name,
      "email" => user.email,
      "username" => user.username,
      "is_active" => user.is_active,
      "is_superuser" => user.is_superuser}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["data"]["id"]
    assert body["data"]["name"]
    assert body["data"]["email"]
    assert body["data"]["is_active"] == false
    assert body["data"]["is_superuser"] == false
    assert Repo.get_by(User, email: "me@example.net")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! Map.merge(%User{}, @valid_attrs)
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    body = json_response(conn, 200)
    assert body["data"]["id"]
    assert body["data"]["name"]
    assert body["data"]["email"]
    assert body["data"]["is_active"] == false
    assert body["data"]["is_superuser"] == false
    assert Repo.get_by(User, email: "me@example.net")
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! Map.merge(%User{}, @valid_attrs)
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! Map.merge(%User{}, @valid_attrs)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
