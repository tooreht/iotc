defmodule Core.LoRaWAN.GatewayPacketControllerTest do
  use Core.ConnCase

  alias Core.LoRaWAN.GatewayPacket
  @valid_attrs %{crc_status: 42, rf_chain: 42, rssi: 42, snr: 42, time: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, gateway_packet_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    gateway_packet = Repo.insert! %GatewayPacket{}
    conn = get conn, gateway_packet_path(conn, :show, gateway_packet)
    assert json_response(conn, 200)["data"] == %{"id" => gateway_packet.id,
      "gateway_id" => gateway_packet.gateway_id,
      "packet_id" => gateway_packet.packet_id,
      "time" => gateway_packet.time,
      "rf_chain" => gateway_packet.rf_chain,
      "crc_status" => gateway_packet.crc_status,
      "rssi" => gateway_packet.rssi,
      "snr" => gateway_packet.snr}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, gateway_packet_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, gateway_packet_path(conn, :create), gateway_packet: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GatewayPacket, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, gateway_packet_path(conn, :create), gateway_packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    gateway_packet = Repo.insert! %GatewayPacket{}
    conn = put conn, gateway_packet_path(conn, :update, gateway_packet), gateway_packet: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GatewayPacket, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    gateway_packet = Repo.insert! %GatewayPacket{}
    conn = put conn, gateway_packet_path(conn, :update, gateway_packet), gateway_packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    gateway_packet = Repo.insert! %GatewayPacket{}
    conn = delete conn, gateway_packet_path(conn, :delete, gateway_packet)
    assert response(conn, 204)
    refute Repo.get(GatewayPacket, gateway_packet.id)
  end
end
