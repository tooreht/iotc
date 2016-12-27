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

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.insert(:application, changeset)
      |> Ecto.Multi.run(:core_api, fn csf ->
           # %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)
           application = Repo.preload(csf.application, [:user])
           @core_api.application(@core_api, :create,
             [%{app_eui: application.app_eui, user__email: application.user.email}])
         end)

    case Repo.transaction(multi) do
      {:ok, %{application: application, core_api: _}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", application_path(conn, :show, application))
        |> render("show.json", application: application)
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end

  def show(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)
    render(conn, "show.json", application: application)
  end

  def update(conn, %{"id" => id, "application" => application_params}) do
    old = Repo.get!(Application, id)
    changeset = Application.changeset(old, application_params)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.update(:application, changeset)
      |> Ecto.Multi.run(:core_api, fn csf ->
           # %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)
           application = Repo.preload(csf.application, [:user])
           @core_api.application(@core_api, :update,
             [%{app_eui: old.app_eui},
              %{app_eui: application.app_eui, user__email: application.user.email}])
         end)

    case Repo.transaction(multi) do
      {:ok, %{application: application, core_api: _}} ->
        render(conn, "show.json", application: application)
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end

  def delete(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |> Ecto.Multi.delete(:application, application)
      |> Ecto.Multi.run(:core_api, fn csf ->
           # %{uid: user_id} = Appsrv.Authentication.get_user_data(conn)
           @core_api.application(@core_api, :delete,
             [%{app_eui: csf.application.app_eui}])
         end)

    case Repo.transaction(multi) do
      {:ok, %{application: application, core_api: _}} ->
        send_resp(conn, :no_content, "")
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Appsrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end
end
