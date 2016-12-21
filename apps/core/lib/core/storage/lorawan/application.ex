defmodule Core.Storage.LoRaWAN.Application do
  @moduledoc """
  CRUD operations for LoRaWAN.Application
  """

  alias Core.LoRaWAN.Application
  alias Core.Repo
  alias Core.Storage.Utils

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

  def get(%{rev_app_eui: rev_app_eui}) do
    get(%{app_eui: Utils.rev_bytes_to_base16(rev_app_eui)})
  end

  #
  # CREATE
  #

  def create(%{app_eui: _} = params) do
    get(params) ||
    changeset(%Application{}, params)
    |> Repo.insert!
  end

  def create(%{rev_app_eui: rev_app_eui} = params) do
    {_, params} = Map.pop(params, :rev_app_eui)
    create(Map.put(params, :app_eui, Utils.rev_bytes_to_base16(rev_app_eui)))
  end

  #
  # UPDATE
  #

  def update(%{app_eui: app_eui}, params) do
    get(%{app_eui: app_eui})
    |> changeset(params)
    |> Repo.update
  end

  def update(%{rev_app_eui: rev_app_eui} = struct, params) do
    {_, struct} = Map.pop(struct, :rev_app_eui)
    params = if Map.has_key?(params, :rev_app_eui) do
      {param, params} = Map.pop(params, :rev_app_eui)
      Map.put(params, :app_eui, Utils.rev_bytes_to_base16(param))
    end
    update(Map.put(struct, :app_eui, Utils.rev_bytes_to_base16(rev_app_eui)), params)
  end

  #
  # DELETE
  #

  def delete(%{app_eui: app_eui}) do
    get(%{app_eui: app_eui})
    |> Repo.delete!
  end

  def delete(%{rev_app_eui: rev_app_eui}) do
    delete(%{app_eui: Utils.rev_bytes_to_base16(rev_app_eui)})
  end
end
