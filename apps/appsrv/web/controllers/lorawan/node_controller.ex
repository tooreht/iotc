defmodule Appsrv.LoRaWAN.NodeController do
  use Appsrv.Web, :controller

  alias Appsrv.LoRaWAN.Node

  def index(conn, _params) do
    lorawan_nodes = Repo.all(Node)
    render(conn, "index.json", lorawan_nodes: lorawan_nodes)
  end

  def create(conn, %{"node" => node_params}) do
    changeset = Node.changeset(%Node{}, node_params)

    case Repo.insert(changeset) do
      {:ok, node} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", node_path(conn, :show, node))
        |> render("show.json", node: node)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    node = Repo.get!(Node, id)
    render(conn, "show.json", node: node)
  end

  def update(conn, %{"id" => id, "node" => node_params}) do
    node = Repo.get!(Node, id)
    changeset = Node.changeset(node, node_params)

    case Repo.update(changeset) do
      {:ok, node} ->
        render(conn, "show.json", node: node)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    node = Repo.get!(Node, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(node)

    send_resp(conn, :no_content, "")
  end
end
