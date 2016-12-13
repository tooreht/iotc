defmodule Core.LoRaWAN.GatewayControllerTest do
  use Core.ConnCase

  alias Core.LoRaWAN.Gateway
  alias Core.User
  alias Coherence.Authentication.Token
  
  @valid_attrs %{
    adapter: "Semtech",
    altitude: Decimal.new("120.5"),
    gw_eui: "B827EBFFFE7B80CD",
    ip: "10.0.0.11",
    last_seen: %Ecto.DateTime{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
    latitude: Decimal.new("120.5"),
    longitude: Decimal.new("120.5")
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
    conn = get conn, gateway_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: _} do
    gateway = Repo.insert! Gateway.changeset(%Gateway{}, @valid_attrs)
    conn = get conn, gateway_path(conn, :show, gateway)
    assert json_response(conn, 200)["data"] == %{
      "id" => gateway.id,
      "gw_eui" => gateway.gw_eui,
      "ip" => gateway.ip,
      "last_seen" => Ecto.DateTime.to_iso8601(gateway.last_seen),
      "adapter" => gateway.adapter,
      "latitude" => Decimal.to_string(gateway.latitude),
      "longitude" => Decimal.to_string(gateway.longitude),
      "altitude" => Decimal.to_string(gateway.altitude),
      "user_id" => gateway.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: _} do
    assert_error_sent 404, fn ->
      get conn, gateway_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: _} do
    conn = post conn, gateway_path(conn, :create), gateway: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Gateway, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: _} do
    conn = post conn, gateway_path(conn, :create), gateway: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: _} do
    gateway = Repo.insert! %Gateway{}
    conn = put conn, gateway_path(conn, :update, gateway), gateway: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Gateway, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: _} do
    gateway = Repo.insert! %Gateway{}
    conn = put conn, gateway_path(conn, :update, gateway), gateway: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: _} do
    gateway = Repo.insert! Gateway.changeset(%Gateway{}, @valid_attrs)
    conn = delete conn, gateway_path(conn, :delete, gateway)
    assert response(conn, 204)
    refute Repo.get(Gateway, gateway.id)
  end
end
