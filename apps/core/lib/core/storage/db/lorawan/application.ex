defmodule Core.Storage.DB.LoRaWAN.Application do
  @moduledoc """
  CRUD operations for LoRaWAN.Application
  """
  @behaviour Core.Storage

  alias Core.LoRaWAN.Application
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

  def create(%{app_eui: _} = params) do
    get(params) ||
    changeset(%Application{}, params)
    |> Repo.insert
  end

  #
  # UPDATE
  #

  def update(%{app_eui: app_eui}, params) do
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
end
