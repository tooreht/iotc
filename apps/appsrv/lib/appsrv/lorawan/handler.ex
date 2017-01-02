defmodule Appsrv.LoRaWAN.Handler do
  @moduledoc """
  This module is responsible for handling LoRaWAN application data.
  """
  use GenServer

  require Logger

  ## Client API

  @doc """
  Starts the storage API with the given `name`.
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @doc """
  Send LoRaWAN application data.
  """
  def send(pid, packet, dev_eui) do
    GenServer.call(pid, {:receive, {packet, dev_eui}})
  end

  @doc """
  Receive LoRaWAN application data.
  """
  def receive(pid, packet, dev_eui) do
    GenServer.call(pid, {:receive, {packet, dev_eui}})
  end

  ## Server Callbacks

  def handle_call({:send, {packet, dev_eui}}, _from, state) do

    # TODO: Implement sending messages to network server

    {:reply, :ok, state}
  end

  def handle_call({:receive, {packet, dev_eui}}, _from, state) do

    # TODO: Implement receiving messages to network server

    {:reply, :ok, state}
  end
end
