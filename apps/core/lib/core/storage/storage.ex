defmodule Core.Storage do
  @moduledoc """
  Storage API for LoRaWAN related data.
  """
  use GenServer

  ## Client API

  @doc """
  Starts the storage API with the given `name`.
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, {}}
  end
end
