defmodule NwkSrv.LoRaWAN.Gateway.StatisticsController do
  use NwkSrv.Web, :controller

  alias NwkSrv.LoRaWAN.Gateway.Statistics

  def index(conn, params) do
    page = Repo.paginate(Statistics, params)
    render(conn, "index.json",
      lorawan_gateway_statistics: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries)
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
        |> render(NwkSrv.ChangesetView, "error.json", changeset: changeset)
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
        |> render(NwkSrv.ChangesetView, "error.json", changeset: changeset)
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
