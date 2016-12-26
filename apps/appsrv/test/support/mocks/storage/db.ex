defmodule Appsrv.Mocks.Storage.DB do
  @moduledoc """
  Mock for the `Core.Storage.DB` module.
  """
  use GenServer

  ## Client API

  @doc """
  Starts the storage API with the given `name`.
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @doc """
  Stores lorawan `packet`.
  """
  def application(server, action, params) do
    GenServer.call(server, {:application, action, params})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, {}}
  end

  def handle_call({:application, action, params}, _from, state) when action in [:get, :create, :update, :delete] do
    response = apply(Appsrv.Mocks.Storage.DB.LoRaWAN.Application, action, params)
    {:reply, response, state}
  end
end
