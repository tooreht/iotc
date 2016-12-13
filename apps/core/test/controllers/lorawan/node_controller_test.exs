defmodule Core.LoRaWAN.NodeControllerTest do
  use Core.ConnCase

  alias Core.LoRaWAN.Node
  alias Core.User
  alias Coherence.Authentication.Token

  @valid_attrs %{
    dev_eui: "2A2B3D4E5F66778A",
    frames_down: 42,
    frames_up: 42,
    last_seen: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
    nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
    status: 42
  }
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
    conn = get conn, node_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: _} do
    node = Repo.insert! %Node{}
    conn = get conn, node_path(conn, :show, node)
    assert json_response(conn, 200)["data"] == %{"id" => node.id,
      "dev_eui" => node.dev_eui,
      "device_address_id" => node.device_address_id,
      "application_id" => node.application_id,
      "nwk_s_key" => node.nwk_s_key,
      "last_seen" => node.last_seen,
      "frames_up" => node.frames_up,
      "frames_down" => node.frames_down,
      "status" => node.status,
      "user_id" => node.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: _} do
    assert_error_sent 404, fn ->
      get conn, node_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: _} do
    conn = post conn, node_path(conn, :create), node: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Node, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: _} do
    conn = post conn, node_path(conn, :create), node: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: _} do
    node = Repo.insert! %Node{}
    conn = put conn, node_path(conn, :update, node), node: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Node, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: _} do
    node = Repo.insert! %Node{}
    conn = put conn, node_path(conn, :update, node), node: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: _} do
    node = Repo.insert! %Node{}
    conn = delete conn, node_path(conn, :delete, node)
    assert response(conn, 204)
    refute Repo.get(Node, node.id)
  end
end
