 defmodule LoRaWAN.Gateway.Handler do
  @moduledoc """
  This module handles LoRaWAN gateways.

  All LoRaWAN gateway protocol adapters communicate to gateway handlers
  as their interface. Each gateway has its own gateway handler.
  The gateway handler checks for every packet if the gateway is registered
  in the system to drop falsy packets as early as possible.
  The gateway handler is also responsible for the dispatching of gateway packets
  whithin the lorawan app.
  """
  use GenServer
  require Logger
  alias Core.Storage

  ## CLIENT API

  @doc """
  Starts the handler with the given `gateway_ip`.
  """
  def start_link(gateway_ip, opts \\ []) do
    GenServer.start_link(__MODULE__, {:ok, gateway_ip}, opts)
  end

  @doc """
  Receive gateway packets.
  """
  def receive(pid, packet) do
    GenServer.call(pid, {:receive, packet})
  end

  ## SERVER CALLBACKS

  @doc """
  Initializes the handler with the given `gateway_ip`.
  """
  def init({:ok, gateway_ip}) do
    # TODO: Register gateway
    {:ok, %{gateway_ip: gateway_ip}}
  end

  @doc """
  Process gateway packets.

  1. Check if the `gateway_eui` in the packets is registred in the system.
  2. Send the packet to worker pool (async) if in system else drop the packet and log it.
  """
  def handle_call({:receive, packet}, _from, state) do
    # Verify that the gateway is registered in the system.
    in_system = Storage.lookup_gateway_eui(Storage, packet.gateway.eui)
    if in_system do
      if %LoRaWAN.Gateway.Packet{} = packet do
        # Send all packets coming from this gateway to the pool.
        LoRaWAN.parallel_pool(packet.lorawan, &LoRaWAN.Worker.receive/2)
        Storage.store_gateway_meta(Storage, packet.gateway)
      end
    else
       Logger.warn "Unregistered gateway #{inspect(packet.gateway.ip)} #{inspect(packet.gateway.eui)}"
    end

    {:reply, {:ok, in_system}, state}
  end
end
