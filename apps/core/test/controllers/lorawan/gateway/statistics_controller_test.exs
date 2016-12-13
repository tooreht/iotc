defmodule Core.LoRaWAN.Gateway.StatisticsControllerTest do
  use Core.ConnCase

  alias Core.LoRaWAN.Gateway.Statistics
  alias Core.User
  alias Coherence.Authentication.Token

  @valid_attrs %{
    ack_rate: "120.5",
    altitude: "120.5",
    latitude: "120.5",
    longitude: "120.5",
    rx_forwarded: 42,
    rx_total: 42,
    rx_valid: 42,
    tx_emitted: 42,
    tx_received: 42
  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! Map.merge(%User{}, %{email: "you@example.net", username: "you", password: "secret"})

    token = Token.generate_token
    Token.add_credentials(token, %{uid: user.id}, Coherence.CredentialStore.Agent)

    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "x-auth-token", token)

    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn, user: _} do
    conn = get conn, statistics_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: _} do
    statistics = Repo.insert! %Statistics{}
    conn = get conn, statistics_path(conn, :show, statistics)
    assert json_response(conn, 200)["data"] == %{"id" => statistics.id,
      "latitude" => statistics.latitude,
      "longitude" => statistics.longitude,
      "altitude" => statistics.altitude,
      "rx_total" => statistics.rx_total,
      "rx_valid" => statistics.rx_valid,
      "rx_forwarded" => statistics.rx_forwarded,
      "tx_received" => statistics.tx_received,
      "tx_emitted" => statistics.tx_emitted,
      "ack_rate" => statistics.ack_rate,
      "gateway_id" => statistics.gateway_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: _} do
    assert_error_sent 404, fn ->
      get conn, statistics_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: _} do
    conn = post conn, statistics_path(conn, :create), statistics: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Statistics, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: _} do
    conn = post conn, statistics_path(conn, :create), statistics: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: _} do
    statistics = Repo.insert! %Statistics{}
    conn = put conn, statistics_path(conn, :update, statistics), statistics: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Statistics, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: _} do
    statistics = Repo.insert! %Statistics{}
    conn = put conn, statistics_path(conn, :update, statistics), statistics: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: _} do
    statistics = Repo.insert! %Statistics{}
    conn = delete conn, statistics_path(conn, :delete, statistics)
    assert response(conn, 204)
    refute Repo.get(Statistics, statistics.id)
  end
end
