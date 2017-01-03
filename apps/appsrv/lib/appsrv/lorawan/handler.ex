defmodule Appsrv.LoRaWAN.Handler do
  @moduledoc """
  This module is responsible for handling LoRaWAN application data.
  """
  use GenServer

  require Logger

  alias Appsrv.LoRaWAN.Crypto
  alias Appsrv.LoRaWAN.Utils

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
  def send(pid, message, dev_eui) do
    GenServer.call(pid, {:send, {message, dev_eui}})
  end

  @doc """
  Receive LoRaWAN application data.
  """
  def receive(pid, packet, dev_eui) do
    GenServer.call(pid, {:receive, {packet, dev_eui}})
  end

  ## Server Callbacks

  def handle_call({:send, {_message, _dev_eui}}, _from, state) do

    # TODO: Implement sending messages to network server.
    # 1. Encrypt message
    # 2. Send it to the downlink handler of the network server
    #    e.g.: Core.LoRaWAN.DownlinkHandler.push(dev_eui, packet)
    #
    # The downlink handler does the following:
    # 1. Compute MIC
    # 2. Assemble packet
    # 3. Add to downlink queue for sending the message to the node over the
    #    optimal gateway within the nodes next possible receive window.

    {:reply, :ok, state}
  end

  def handle_call({:receive, {packet, dev_eui}}, _from, state) do

    node = Utils.get_node(dev_eui)
    key = Utils.get_key(node, packet.mac_payload.f_port)
    bytes = Crypto.decrypt(packet, key)

    for adapter <- Application.get_env(:appsrv, Appsrv.Adapters) do
      adapter.send(bytes, node)
    end

    {:reply, :ok, state}
  end
end
