defmodule Appsrv.LoRaWAN.NodeController do
  use Appsrv.Web, :controller

  alias Appsrv.LoRaWAN.Node

  @core_api Application.get_env(:appsrv, :core_api)

  def index(conn, _params) do
    lorawan_nodes = Repo.all(Node)
    render(conn, "index.json", lorawan_nodes: lorawan_nodes)
  end

  def create(conn, %{"node" => node_params}) do
    %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)
    node_params = Map.put(node_params, "user_id", user_id)

    changeset = Node.changeset(%Node{}, node_params)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |>  Ecto.Multi.insert(:node, changeset)
      |>  Ecto.Multi.run(:core_api, fn csf ->
            node = Repo.preload(csf.node, [:application, :user])
            @core_api.node(@core_api, :create,
              [%{dev_eui: node.dev_eui, nwk_s_key: node.nwk_s_key,
                application__app_eui: node.application.app_eui, user__email: node.user.email}])
            end)
      |>  Ecto.Multi.run(:adapter_registration, fn csf ->
            node = Repo.preload(csf.node, [:application])
            for adapter <- Application.get_env(:appsrv, Appsrv.Adapters) do
              adapter.register(node.application, node)
            end
            {:ok, node}
          end)

    case Repo.transaction(multi) do
      {:ok, %{node: node, core_api: _, adapter_registration: _}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", node_path(conn, :show, node))
        |> render("show.json", node: node)
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end

  def show(conn, %{"id" => id}) do
    node = Repo.get!(Node, id)
    render(conn, "show.json", node: node)
  end

  def update(conn, %{"id" => id, "node" => node_params}) do
    %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)
    node_params = Map.put(node_params, "user_id", user_id)

    old = Repo.get!(Node, id)
    changeset = Node.changeset(old, node_params)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |>  Ecto.Multi.update(:node, changeset)
      |>  Ecto.Multi.run(:core_api, fn csf ->
            node = Repo.preload(csf.node, [:application, :user])
            @core_api.node(@core_api, :update,
              [%{dev_eui: old.dev_eui}, %{dev_eui: node.dev_eui, nwk_s_key: node.nwk_s_key,
                application__app_eui: node.application.app_eui, user__email: node.user.email}])
          end)
      |>  Ecto.Multi.run(:adapter_registration, fn csf ->
            node = Repo.preload(csf.node, [:application])
            for adapter <- Application.get_env(:appsrv, Appsrv.Adapters) do
              adapter.register(node.application, node)
            end
            {:ok, node}
          end)

    case Repo.transaction(multi) do
      {:ok, %{node: node, core_api: _, adapter_registration: _}} ->
        render(conn, "show.json", node: node)
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end

  def delete(conn, %{"id" => id}) do
    node = Repo.get!(Node, id)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |>  Ecto.Multi.delete(:node, node)
      |>  Ecto.Multi.run(:core_api, fn csf ->
            @core_api.node(@core_api, :delete,
              [%{dev_eui: csf.node.dev_eui}])
          end)

    case Repo.transaction(multi) do
      {:ok, %{node: _, core_api: _}} ->
        send_resp(conn, :no_content, "")
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end
end
