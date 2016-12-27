defmodule Core.Storage.DB.LoRaWAN.Application do
  @moduledoc """
  CRUD operations for LoRaWAN.Application
  """
  @behaviour Core.Storage

  import Ecto.Query, only: [from: 2]

  alias Core.LoRaWAN.Application
  alias Core.User
  alias Core.Repo

  #
  # CHANGESET
  #

  def changeset(struct, params \\ %{}) do
    Application.changeset(struct, params)
  end

  #
  # GET
  #

  def get(%{app_eui: app_eui}) do
    Repo.get_by(Application, app_eui: app_eui)
  end

  #
  # CREATE
  #

  def create(%{app_eui: app_eui, user__email: email} = params) do
    params = clean_params(params)
    changeset(%Application{}, params)
    |> Repo.insert
  end

  #
  # UPDATE
  #

  def update(%{app_eui: app_eui}, params) do
    params = clean_params(params)
    get(%{app_eui: app_eui})
    |> changeset(params)
    |> Repo.update
  end

  #
  # DELETE
  #

  def delete(%{app_eui: app_eui}) do
    get(%{app_eui: app_eui})
    |> Repo.delete
  end

  defp clean_params(params) do
    if Map.has_key?(params, :user__email) do
      {param, params} = Map.pop(params, :user__email)
      Map.put(params, :user_id, from(u in User, where: u.email == ^param, select: u.id) |> Repo.one)
    else
      params
    end
  end
end
