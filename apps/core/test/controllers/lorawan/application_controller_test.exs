defmodule Core.LoRaWAN.ApplicationControllerTest do
  use Core.ConnCase

  alias Core.LoRaWAN.Application
  alias Core.User
  alias Coherence.Authentication.Token

  @valid_attrs %{app_eui: "70B3D57ED0000E36"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! Map.merge(%User{}, %{name: "You", email: "you@example.net", username: "you", password: "secret"})

    token = Token.generate_token
    Token.add_credentials(token, %{uid: user.id}, Coherence.CredentialStore.Agent)

    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "x-auth-token", token)

    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn, user: _} do
    conn = get conn, application_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: _} do
    application = Repo.insert! %Application{}
    conn = get conn, application_path(conn, :show, application)
    assert json_response(conn, 200)["data"] == %{
      "id" => application.id,
      "app_eui" => application.app_eui,
      "user_id" => application.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: _} do
    assert_error_sent 404, fn ->
      get conn, application_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: _} do
    conn = post conn, application_path(conn, :create), application: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Application, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: _} do
    conn = post conn, application_path(conn, :create), application: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: _} do
    application = Repo.insert! %Application{}
    conn = put conn, application_path(conn, :update, application), application: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Application, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: _} do
    application = Repo.insert! %Application{}
    conn = put conn, application_path(conn, :update, application), application: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: _} do
    application = Repo.insert! %Application{}
    conn = delete conn, application_path(conn, :delete, application)
    assert response(conn, 204)
    refute Repo.get(Application, application.id)
  end
end
