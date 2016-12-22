defmodule Core.Storage.LoRaWAN.DeviceAddress do
  @moduledoc """
  CRUD operations for LoRaWAN.Node
  """
  alias Core.LoRaWAN.DeviceAddress
  alias Core.Repo
  alias Core.Storage.Utils

  #
  # CHANGESET
  #

  def changeset(struct, params \\ %{}) do
    DeviceAddress.changeset(struct, params)
  end

  #
  # GET
  #

  def get(%{dev_addr: dev_addr}) do
    Repo.get_by(DeviceAddress, dev_addr: dev_addr)
  end

  #
  # CREATE
  #

  def create(%{dev_addr: _} = params) do
    get(params) ||
    changeset(%DeviceAddress{}, Map.put(params, :last_assigned, DateTime.utc_now))
    |> Repo.insert!
  end

  #
  # UPDATE
  #

  def update(%{dev_addr: dev_addr}, params) do
    get(%{dev_addr: dev_addr})
    |> changeset(params)
    |> Repo.update
  end

  #
  # DELETE
  #

  def delete(%{dev_addr: dev_addr}) do
    get(%{dev_addr: dev_addr})
    |> Repo.delete!
  end
end
