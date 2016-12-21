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

  def get(%{rev_dev_eui: rev_dev_eui}) do
    get(%{dev_eui: Utils.rev_bytes_to_base16(rev_dev_eui)})
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

  def create(%{
    rev_dev_eui: rev_dev_eui,
    rev_nwk_s_key: rev_nwk_s_key,
    application_id: _,
    user_id: _} = params)
  do
    {_, params} = Map.pop(params, :rev_dev_eui)
    params = Map.put(params, :dev_eui, Utils.rev_bytes_to_base16(rev_dev_eui))

    {_, params} = Map.pop(params, :rev_nwk_s_key)
    params = Map.put(params, :nwk_s_key, Utils.rev_bytes_to_base16(rev_nwk_s_key))

    params = if Map.has_key?(params, :rev_dev_addr) do
      {param, params} = Map.pop(params, :rev_dev_addr)
      Map.put(params, :dev_addr, Utils.rev_bytes_to_base16(param))
    else
      params
    end

    create(params)
  end

  #
  # UPDATE
  #

  def update(%{dev_eui: dev_eui}, params) do
    get(%{dev_eui: dev_eui})
    |> changeset(params)
    |> Repo.update
  end

  def update(%{rev_dev_eui: rev_dev_eui} = struct, params) do
    {param, params} = Map.pop(params, :rev_dev_eui)
    params = Map.put(params, :dev_eui, Utils.rev_bytes_to_base16(param))

    params = if Map.has_key?(params, :rev_nwk_s_key) do
      {param, params} = Map.pop(params, :rev_nwk_s_key)
      Map.put(params, :nwk_s_key, Utils.rev_bytes_to_base16(param))
    else
      params
    end

    params = if Map.has_key?(params, :rev_dev_addr) do
      {param, params} = Map.pop(params, :rev_dev_addr)
      Map.put(params, :dev_addr, Utils.rev_bytes_to_base16(param))
    else
      params
    end

    update(Map.put(struct, :dev_eui, Utils.rev_bytes_to_base16(rev_dev_eui)), params)
  end

  #
  # DELETE
  #

  def delete(%{dev_eui: dev_eui}) do
    get(%{dev_eui: dev_eui})
    |> Repo.delete!
  end

  def delete(%{rev_dev_eui: rev_dev_eui}) do
    delete(%{dev_eui: Utils.rev_bytes_to_base16(rev_dev_eui)})
  end
end
