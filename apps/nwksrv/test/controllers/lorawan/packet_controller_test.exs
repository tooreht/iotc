defmodule NwkSrv.LoRaWAN.PacketControllerTest do
  use NwkSrv.ConnCase

  alias NwkSrv.LoRaWAN.Packet
  alias NwkSrv.User
  alias Coherence.Authentication.Token

  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}

    token = Token.generate_token
    Token.add_credentials(token, %{uid: user.id}, Coherence.CredentialStore.Agent)

    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "x-auth-token", token)

    application = Repo.insert! %NwkSrv.LoRaWAN.Application{
                              app_eui: "704FD42E1A0C15C8",
                              user_id: user.id
                            }
    device_address = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "79D2A146", last_assigned: Ecto.DateTime.utc}
    node = Repo.insert! %NwkSrv.LoRaWAN.Node{
                        dev_eui: "2A2B3D4E5F66778A",
                        device_address_id: device_address.id,
                        nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
                        application_id: application.id,
                        user_id: user.id
                      }

    valid_attrs = %{
      channel: 42,
      code_rate: "4/5",
      data_rate: "SF7BW125",
      frequency: "120.5",
      modulation: "LORA",
      number: 42,
      size: 42,
      type: 42,
      node_id: node.id
    }

    {:ok, conn: conn, valid_attrs: valid_attrs}
  end

  test "lists all entries on index", %{conn: conn, valid_attrs: _} do
    conn = get conn, packet_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, valid_attrs: _} do
    packet = Repo.insert! %Packet{}
    conn = get conn, packet_path(conn, :show, packet)
    assert json_response(conn, 200)["data"] == %{
      "id" => packet.id,
      "number" => packet.number,
      "dev_nonce" => nil,
      "type" => packet.type,
      "frequency" => packet.frequency,
      "channel" => packet.channel,
      "modulation" => packet.modulation,
      "data_rate" => packet.data_rate,
      "code_rate" => packet.code_rate,
      "size" => packet.size,
      "node_id" => packet.node_id,
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn, valid_attrs: _} do
    assert_error_sent 404, fn ->
      get conn, packet_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, packet_path(conn, :create), packet: valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Packet, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, valid_attrs: _} do
    conn = post conn, packet_path(conn, :create), packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    packet = Repo.insert! %Packet{}
    conn = put conn, packet_path(conn, :update, packet), packet: valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Packet, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, valid_attrs: _} do
    packet = Repo.insert! %Packet{}
    conn = put conn, packet_path(conn, :update, packet), packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, valid_attrs: _} do
    packet = Repo.insert! %Packet{}
    conn = delete conn, packet_path(conn, :delete, packet)
    assert response(conn, 204)
    refute Repo.get(Packet, packet.id)
  end
end
