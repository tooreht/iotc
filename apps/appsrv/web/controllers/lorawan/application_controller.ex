defmodule Appsrv.LoRaWAN.ApplicationController do
  use Appsrv.Web, :controller

  @core_api Application.get_env(:appsrv, :core_api)

  alias Appsrv.LoRaWAN.Application

  def index(conn, _params) do
    lorawan_applications = Repo.all(Application)
    render(conn, "index.json", lorawan_applications: lorawan_applications)
  end

  def create(conn, %{"application" => application_params}) do
    changeset = Application.changeset(%Application{}, application_params)
    %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)

    with {:ok, application} <- Repo.insert(changeset),
         {:ok, _} <- @core_api.application(@core_api, :create,
                       [%{app_eui: application.app_eui, user_id: user_id}])
    do
      conn
      |> put_status(:created)
      |> put_resp_header("location", application_path(conn, :show, application))
      |> render("show.json", application: application)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)
    render(conn, "show.json", application: application)
  end

  def update(conn, %{"id" => id, "application" => application_params}) do
    old = Repo.get!(Application, id)
    changeset = Application.changeset(old, application_params)
    %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)

    with {:ok, new} <- Repo.update(changeset),
         {:ok, _} <- @core_api.application(@core_api, :update,
                       [%{app_eui: old.app_eui}, %{app_eui: new.app_eui, user_id: user_id}])
    do
      render(conn, "show.json", application: new)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)
    %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(application)
    @core_api.application(@core_api, :delete, [%{app_eui: application.app_eui, user_id: user_id}])

    send_resp(conn, :no_content, "")
  end
end
