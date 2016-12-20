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
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @doc """
  Looks up the `gateway_eui`.
  """
  def lookup_gateway_eui(server, gateway_eui) do
    GenServer.call(server, {:lookup_gateway_eui, gateway_eui})
  end

  @doc """
  Stores gateway `meta` data.
  """
  def store_gateway_meta(server, meta) do
    GenServer.call(server, {:store_gateway_meta, meta})
  end

  @doc """
  Stores lorawan `packet`.
  """
  def store_packet(server, packet) do
    GenServer.call(server, {:store_packet, packet})
  end

  @doc """
  Stores lorawan packet `meta` data.
  """
  def store_packet_meta(server, meta) do
    GenServer.call(server, {:store_packet_meta, meta})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, {}}
  end

  def handle_call({:lookup_gateway_eui, gateway_eui}, _from, state) do
    response = Storage.LoRaWAN.Gateway.lookup_gateway_eui(gateway_eui)
    {:reply, response, state}
  end

  def handle_call({:store_gateway_meta, meta}, _from, state) do
    response = Storage.LoRaWAN.Gateway.store_gateway_meta(meta)
    {:reply, response, state}
  end

  def handle_call({:store_packet, packet}, _from, state) do
    response = Storage.Utils.store_packet(packet)
    {:reply, response, state}
  end

  def handle_call({:store_packet_meta, meta}, _from, state) do
    response = Storage.Utils.store_packet_meta(meta)
    {:reply, response, state}
  end
end
