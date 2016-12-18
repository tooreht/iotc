defmodule Core.Storage do
  @moduledoc """
  Storage API for LoRaWAN related data.
  """
  use GenServer
  alias Core.Storage

  ## Client API

  @doc """
  Starts the storage API with the given `name`.
  """
  def start_link(name, opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, Enum.concat(opts, name: name))
  end

  @doc """
  Looks up the `gateway_eui`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup_gateway_eui(server, gateway_eui) do
    GenServer.call(server, {:lookup_gateway_eui, gateway_eui})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, {}}
  end

  def handle_call({:lookup_gateway_eui, gateway_eui}, _from, state) do
    response = Storage.LoRaWAN.lookup_gateway_eui(gateway_eui)
    {:reply, response, state}
  end
end
