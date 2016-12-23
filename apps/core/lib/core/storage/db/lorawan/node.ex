defmodule Core.Storage.DB.LoRaWAN.Node do
  @moduledoc """
  CRUD operations for LoRaWAN.Node
  """
  @behaviour Core.Storage

  import Ecto.Query, only: [from: 2]

  alias Core.LoRaWAN.DeviceAddress
  alias Core.LoRaWAN.Node
  alias Core.Repo

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
    dev_eui: _,
    nwk_s_key: _,
    application_id: _,
    user_id: _} = params)
  do
    get(params) ||
    changeset(%Node{}, params)
    |> Repo.insert
  end

  #
  # UPDATE
  #

  def update(%{dev_eui: dev_eui}, params) do
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
end
