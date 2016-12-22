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

  def get(%{rev_dev_addr: rev_dev_addr}) do
    get(%{dev_addr: Utils.rev_bytes_to_base16(rev_dev_addr)})
  end

  #
  # CREATE
  #

  def create(%{dev_addr: _} = params) do
    get(params) ||
    changeset(%DeviceAddress{}, Map.put(params, :last_assigned, DateTime.utc_now))
    |> Repo.insert!
  end

  def create(%{rev_dev_addr: rev_dev_addr} = params) do
    {_, params} = Map.pop(params, :rev_dev_addr)
    create(Map.put(params, :dev_addr, Utils.rev_bytes_to_base16(rev_dev_addr)))
  end

  #
  # UPDATE
  #

  def update(%{dev_addr: dev_addr}, params) do
    get(%{dev_addr: dev_addr})
    |> changeset(params)
    |> Repo.update
  end

  def update(%{rev_dev_addr: rev_dev_addr} = struct, params) do
    {_, struct} = Map.pop(struct, :rev_dev_addr)
    params = if Map.has_key?(params, :rev_dev_addr) do
      {param, params} = Map.pop(params, :rev_dev_addr)
      Map.put(params, :dev_addr, Utils.rev_bytes_to_base16(param))
    end
    update(Map.put(struct, :dev_addr, Utils.rev_bytes_to_base16(rev_dev_addr)), params)
  end

  #
  # DELETE
  #

  def delete(%{dev_addr: dev_addr}) do
    get(%{dev_addr: dev_addr})
    |> Repo.delete!
  end

  def delete(%{rev_dev_addr: rev_dev_addr}) do
    delete(%{dev_addr: Utils.rev_bytes_to_base16(rev_dev_addr)})
  end
end
