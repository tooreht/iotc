defmodule Core.Storage.LoRaWAN.Node do
  @moduledoc """
  CRUD operations for LoRaWAN.Node
  """

  alias Core.LoRaWAN.Node
  alias Core.Repo
  alias Core.Storage.Utils

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
    |> Repo.insert!
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
    |> Repo.delete!
  end
end
