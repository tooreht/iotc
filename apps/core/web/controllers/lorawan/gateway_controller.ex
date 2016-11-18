defmodule Core.LoRaWAN.GatewayController do
  use Core.Web, :controller

  alias Core.LoRaWAN.Gateway

  def index(conn, _params) do
    lorawan_gateways = Repo.all(Gateway)
    render(conn, "index.json", lorawan_gateways: lorawan_gateways)
  end

  def create(conn, %{"gateway" => gateway_params}) do
    changeset = Gateway.changeset(%Gateway{}, gateway_params)

    case Repo.insert(changeset) do
      {:ok, gateway} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", gateway_path(conn, :show, gateway))
        |> render("show.json", gateway: gateway)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gateway = Repo.get!(Gateway, id)
    render(conn, "show.json", gateway: gateway)
  end

  def update(conn, %{"id" => id, "gateway" => gateway_params}) do
    gateway = Repo.get!(Gateway, id)
    changeset = Gateway.changeset(gateway, gateway_params)

    case Repo.update(changeset) do
      {:ok, gateway} ->
        render(conn, "show.json", gateway: gateway)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gateway = Repo.get!(Gateway, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(gateway)

    send_resp(conn, :no_content, "")
  end
end
