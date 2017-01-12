defmodule NwkSrv.Storage.DB.LoRaWAN.Node do
  @moduledoc """
  CRUD operations for LoRaWAN.Node
  """
  @behaviour NwkSrv.Storage

  import Ecto.Query, only: [from: 2]

  alias NwkSrv.LoRaWAN.Application
  alias NwkSrv.LoRaWAN.DeviceAddress
  alias NwkSrv.LoRaWAN.Node
  alias NwkSrv.User
  alias NwkSrv.Repo

  #
  # CHANGESET
  #

  def changeset(struct, params \\ %{}) do
    Node.changeset(struct, params)
  end

  #
  # GET
  #

  def get(%{dev_eui: dev_eui}) do
    Repo.get_by(Node, dev_eui: dev_eui)
  end

  #
  # CREATE
  #

  def create(%{
    dev_eui: dev_eui,
    nwk_s_key: nwk_s_key,
    application__app_eui: app_eui,
    user__email: email} = params)
  do
    params = clean_params(params)
    changeset(%Node{}, params)
    |> Repo.insert
  end

  #
  # UPDATE
  #

  def update(%{dev_eui: dev_eui}, params) do
    params = clean_params(params)
    get(%{dev_eui: dev_eui})
    |> changeset(params)
    |> Repo.update
  end

  #
  # DELETE
  #

  def delete(%{dev_eui: dev_eui}) do
    get(%{dev_eui: dev_eui})
    |> Repo.delete
  end

  #
  # HELPERS
  #

  def get_nodes(%{dev_addr: dev_addr, f_cnt: f_cnt}) do
    from(n in Node,
      join: d in DeviceAddress,
      on: n.device_address_id == d.id,
      # where: n.frames_up == ^f_cnt,
      where: d.dev_addr == ^dev_addr,
      # preload: [:device_address],
      select: n)
    |> Repo.all
  end

  defp clean_params(params) do
    params = if Map.has_key?(params, :application__app_eui) do
      {param, params} = Map.pop(params, :application__app_eui)
      Map.put(params, :application_id, from(a in Application, where: a.app_eui == ^param, select: a.id) |> Repo.one)
    else
      params
    end
    params = if Map.has_key?(params, :user__email) do
      {param, params} = Map.pop(params, :user__email)
      Map.put(params, :user_id, from(u in User, where: u.email == ^param, select: u.id) |> Repo.one)
    else
      params
    end
  end
end
