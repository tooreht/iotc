defmodule AppSrv.LoRaWAN.NodeControllerTest do
  use AppSrv.ConnCase

  alias AppSrv.LoRaWAN.Node
  alias AppSrv.User
  alias Coherence.Authentication.Token

  @invalid_attrs %{}

  setup %{conn: conn} do
    AppSrv.Mocks.Storage.DB.start_link(AppSrv.Mocks.Storage.DB)

    user = Repo.insert! %User{name: "You", email: "you@example.net", username: "you", password: "secret"}

    token = Token.generate_token
    Token.add_credentials(token, %{uid: user.id}, Coherence.CredentialStore.Agent)

    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "x-auth-token", token)

    application = Repo.insert! %AppSrv.LoRaWAN.Application{
      app_eui: "70B3D57ED0000E36",
      app_root_key: "9056E66E691EC92131DC6A16DB533C42",
      name: "AlloAllo",
      user_id: user.id
    }
    
    valid_attrs = %{
      name: "AlloAllo",
      dev_eui: "2A2B3D4E5F66778A",
      dev_addr: "1CF3BA77",
      app_key: "9056E66E691EC92131DC6A16DB533C81",
      app_s_key: "8997C1DDA114D001B15E6CB58DB538A6",
      nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
      relax_fcnt: true,
      rx1_dr_offset: 42,
      rx2_dr: 42,
      rx_delay: 42,
      rx_window: 42,
      application_id: application.id,
      user_id: user.id
    }

    {:ok, conn: conn, valid_attrs: valid_attrs}
  end

  test "lists all entries on index", %{conn: conn, valid_attrs: _} do
    conn = get conn, node_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, valid_attrs: valid_attrs} do
    node = Repo.insert! Node.changeset(%Node{}, valid_attrs)
    conn = get conn, node_path(conn, :show, node)
    assert json_response(conn, 200)["data"] == %{
      "id" => node.id,
      "name" => node.name,
      "dev_eui" => node.dev_eui,
      "dev_addr" => node.dev_addr,
      "app_key" => node.app_key,
      "app_s_key" => node.app_s_key,
      "nwk_s_key" => node.nwk_s_key,
      "relax_fcnt" => node.relax_fcnt,
      "rx_window" => node.rx_window,
      "rx_delay" => node.rx_delay,
      "rx1_dr_offset" => node.rx1_dr_offset,
      "rx2_dr" => node.rx2_dr,
      "application_id" => node.application_id,
      "user_id" => node.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, valid_attrs: _} do
    assert_error_sent 404, fn ->
      get conn, node_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, node_path(conn, :create), node: valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Node, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, valid_attrs: _} do
    conn = post conn, node_path(conn, :create), node: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    node = Repo.insert! %Node{}
    conn = put conn, node_path(conn, :update, node), node: valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Node, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, valid_attrs: _} do
    node = Repo.insert! %Node{}
    conn = put conn, node_path(conn, :update, node), node: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, valid_attrs: _} do
    node = Repo.insert! %Node{}
    conn = delete conn, node_path(conn, :delete, node)
    assert response(conn, 204)
    refute Repo.get(Node, node.id)
  end
end
