defmodule Core.LoRaWAN.GatewayPacketControllerTest do
  use Core.ConnCase

  alias Core.LoRaWAN.GatewayPacket
  alias Core.User
  alias Coherence.Authentication.Token

  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}

    token = Token.generate_token
    Token.add_credentials(token, %{uid: user.id}, Coherence.CredentialStore.Agent)

    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "x-auth-token", token)

    %{id: gateway_id} = Core.Storage.LoRaWAN.Gateway.create(%{gw_eui: "B827EBFFFE7FE413", adapter: "Semtech", user_id: user.id})
    %{id: application_id} = Core.Storage.LoRaWAN.Application.create(%{
                              app_eui: "704FD42E1A0C15C8",
                              user_id: user.id
                            })
    %{id: node_id} = Core.Storage.LoRaWAN.Node.create(%{
                        dev_eui: "2A2B3D4E5F66778A",
                        dev_addr: "00000002",
                        nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
                        application_id: application_id,
                        user_id: user.id
                      })
    %{id: packet_id} = Core.Storage.LoRaWAN.Packet.create(%{
                         type: 3,
                         number: 123,
                         frequency: "868.0",
                         channel: 42,
                         modulation: "LORA" ,
                         data_rate: "SF7BW125",
                         code_rate: "4/5",
                         size: 42,
                         node_id: node_id
                       })

    valid_attrs = %{
      crc_status: 42,
      rf_chain: 42,
      rssi: 42,
      snr: 42,
      time: 42,
      gateway_id: gateway_id,
      packet_id: packet_id
    }

    {:ok, conn: conn, valid_attrs: valid_attrs}
  end

  test "lists all entries on index", %{conn: conn, valid_attrs: _} do
    conn = get conn, gateway_packet_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, valid_attrs: _} do
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

  test "renders page not found when id is nonexistent", %{conn: conn, valid_attrs: _} do
    assert_error_sent 404, fn ->
      get conn, gateway_packet_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, gateway_packet_path(conn, :create), gateway_packet: valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GatewayPacket, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, valid_attrs: _} do
    conn = post conn, gateway_packet_path(conn, :create), gateway_packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    gateway_packet = Repo.insert! %GatewayPacket{}
    conn = put conn, gateway_packet_path(conn, :update, gateway_packet), gateway_packet: valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GatewayPacket, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, valid_attrs: _} do
    gateway_packet = Repo.insert! %GatewayPacket{}
    conn = put conn, gateway_packet_path(conn, :update, gateway_packet), gateway_packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, valid_attrs: _} do
    gateway_packet = Repo.insert! %GatewayPacket{}
    conn = delete conn, gateway_packet_path(conn, :delete, gateway_packet)
    assert response(conn, 204)
    refute Repo.get(GatewayPacket, gateway_packet.id)
  end
end
