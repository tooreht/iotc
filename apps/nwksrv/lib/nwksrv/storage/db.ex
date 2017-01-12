defmodule NwkSrv.Storage.DB do
  @moduledoc """
  Storage API for LoRaWAN related data.

  ## Behaviour

  Storage defines a basic CRUD interface for resource access.
  """
  use GenServer

  @crud_actions [:get, :create, :update, :delete]

  ## Client API

  @doc """
  Starts the storage API with the given `name`.
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @doc """
  CRUD for `LoRaWAN.Application`.
  """
  def application(server, action, params) do
    GenServer.call(server, {:application, action, params})
  end

  @doc """
  CRUD for `LoRaWAN.Node`.
  """
  def node(server, action, params) do
    GenServer.call(server, {:node, action, params})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, {}}
  end

  def handle_call({:application, action, params}, _from, state) when action in @crud_actions do
    response = apply(NwkSrv.Storage.DB.LoRaWAN.Application, action, params)
    {:reply, response, state}
  end

  def handle_call({:node, action, params}, _from, state) when action in @crud_actions do
    response = apply(NwkSrv.Storage.DB.LoRaWAN.Node, action, params)
    {:reply, response, state}
  end
end
