defmodule AppSrv.LoRaWAN.ApplicationController do
  use AppSrv.Web, :controller

  @nwksrv_api Application.get_env(:appsrv, :nwksrv_api)

  alias AppSrv.LoRaWAN.Application

  def index(conn, _params) do
    lorawan_applications = Repo.all(Application)
    render(conn, "index.json", lorawan_applications: lorawan_applications)
  end

  def create(conn, %{"application" => application_params}) do
    %{uid: user_id} = AppSrv.Authentication.get_user_data(conn)
    application_params = Map.put(application_params, "user_id", user_id)

    changeset = Application.changeset(%Application{}, application_params)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |>  Ecto.Multi.insert(:application, changeset)
      |>  Ecto.Multi.run(:nwksrv_api, fn csf ->
            application = Repo.preload(csf.application, [:user])
            @nwksrv_api.application(@nwksrv_api, :create,
              [%{app_eui: application.app_eui, user__email: application.user.email}])
          end)

    case Repo.transaction(multi) do
      {:ok, %{application: application, nwksrv_api: _}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", application_path(conn, :show, application))
        |> render("show.json", application: application)
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AppSrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end

  def show(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)
    render(conn, "show.json", application: application)
  end

  def update(conn, %{"id" => id, "application" => application_params}) do
    %{uid: user_id} = AppSrv.Authentication.get_user_data(conn)
    application_params = Map.put(application_params, "user_id", user_id)

    old = Repo.get!(Application, id)
    changeset = Application.changeset(old, application_params)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |>  Ecto.Multi.update(:application, changeset)
      |>  Ecto.Multi.run(:nwksrv_api, fn csf ->
            application = Repo.preload(csf.application, [:user])
            @nwksrv_api.application(@nwksrv_api, :update,
              [%{app_eui: old.app_eui},
              %{app_eui: application.app_eui, user__email: application.user.email}])
          end)

    case Repo.transaction(multi) do
      {:ok, %{application: application, nwksrv_api: _}} ->
        render(conn, "show.json", application: application)
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AppSrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end

  def delete(conn, %{"id" => id}) do
    application = Repo.get!(Application, id)

    # TODO: Maybe outsource multi to NodeService module?
    multi =
      Ecto.Multi.new
      |>  Ecto.Multi.delete(:application, application)
      |>  Ecto.Multi.run(:nwksrv_api, fn csf ->
            @nwksrv_api.application(@nwksrv_api, :delete,
              [%{app_eui: csf.application.app_eui}])
          end)

    case Repo.transaction(multi) do
      {:ok, %{application: _, nwksrv_api: _}} ->
        send_resp(conn, :no_content, "")
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AppSrv.ChangesetView, "error.json", changeset: failed_value)
    end
  end
end
