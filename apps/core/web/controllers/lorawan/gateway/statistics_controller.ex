defmodule Core.LoRaWAN.Gateway.StatisticsController do
  use Core.Web, :controller

  alias Core.LoRaWAN.Gateway.Statistics

  def index(conn, _params) do
    lorawan_gateway_statistics = Repo.all(Statistics)
    render(conn, "index.json", lorawan_gateway_statistics: lorawan_gateway_statistics)
  end

  def create(conn, %{"statistics" => statistics_params}) do
    changeset = Statistics.changeset(%Statistics{}, statistics_params)

    case Repo.insert(changeset) do
      {:ok, statistics} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", statistics_path(conn, :show, statistics))
        |> render("show.json", statistics: statistics)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    statistics = Repo.get!(Statistics, id)
    render(conn, "show.json", statistics: statistics)
  end

  def update(conn, %{"id" => id, "statistics" => statistics_params}) do
    statistics = Repo.get!(Statistics, id)
    changeset = Statistics.changeset(statistics, statistics_params)

    case Repo.update(changeset) do
      {:ok, statistics} ->
        render(conn, "show.json", statistics: statistics)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    statistics = Repo.get!(Statistics, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(statistics)

    send_resp(conn, :no_content, "")
  end
end