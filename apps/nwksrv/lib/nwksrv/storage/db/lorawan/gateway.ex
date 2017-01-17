defmodule NwkSrv.Storage.DB.LoRaWAN.Gateway do
  @moduledoc """
  CRUD operations for LoRaWAN.Gateway

  - Ecto queries for persistence
  """
  @behaviour NwkSrv.Storage

  import Ecto.Query, only: [from: 2]

  alias NwkSrv.LoRaWAN.Gateway
  alias NwkSrv.Repo

  #
  # CHANGESET
  #

  def changeset(struct, params \\ %{}) do
    Gateway.changeset(struct, params)
  end

  #
  # GET
  #

  def get(%{gw_eui: gw_eui}) do
    Repo.get_by(Gateway, gw_eui: gw_eui)
  end

  #
  # CREATE
  #

  def create(%{gw_eui: _, adapter: _, user_id: _} = params) do
    get(params) ||
    changeset(%Gateway{}, params)
    |> Repo.insert
  end

  #
  # UPDATE
  #

  def update(%{gw_eui: gw_eui}, params) do
    get(%{gw_eui: gw_eui})
    |> changeset(params)
    |> Repo.update
  end

  #
  # DELETE
  #

  def delete(%{gw_eui: gw_eui}) do
    get(%{gw_eui: gw_eui})
    |> Repo.delete
  end

  #
  # HELPERS
  #

  def query_gateway_euis do
    from(g in Gateway, select: g.gw_eui)
    |> Repo.all()
  end
end
