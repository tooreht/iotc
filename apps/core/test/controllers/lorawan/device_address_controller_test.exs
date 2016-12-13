defmodule Core.LoRaWAN.DeviceAddressControllerTest do
  use Core.ConnCase

  alias Core.LoRaWAN.DeviceAddress
  alias Core.User
  alias Coherence.Authentication.Token

  @valid_attrs %{dev_addr: "1CF3BA77", last_assigned: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
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
    conn = get conn, device_address_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: _} do
    device_address = Repo.insert! %DeviceAddress{}
    conn = get conn, device_address_path(conn, :show, device_address)
    assert json_response(conn, 200)["data"] == %{"id" => device_address.id,
      "dev_addr" => device_address.dev_addr,
      "last_assigned" => device_address.last_assigned}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: _} do
    assert_error_sent 404, fn ->
      get conn, device_address_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: _} do
    conn = post conn, device_address_path(conn, :create), device_address: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(DeviceAddress, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: _} do
    conn = post conn, device_address_path(conn, :create), device_address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: _} do
    device_address = Repo.insert! %DeviceAddress{}
    conn = put conn, device_address_path(conn, :update, device_address), device_address: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(DeviceAddress, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: _} do
    device_address = Repo.insert! %DeviceAddress{}
    conn = put conn, device_address_path(conn, :update, device_address), device_address: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: _} do
    device_address = Repo.insert! %DeviceAddress{}
    conn = delete conn, device_address_path(conn, :delete, device_address)
    assert response(conn, 204)
    refute Repo.get(DeviceAddress, device_address.id)
  end
end
