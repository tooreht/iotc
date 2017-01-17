defmodule NwkSrv.Gateway.Handler do
  @moduledoc """
  This module handles LoRaWAN gateways.

  All LoRaWAN gateway protocol adapters communicate to gateway handlers
  as their interface. Each gateway has its own gateway handler.
  The gateway handler checks for every packet if the gateway is registered
  in the system to drop falsy packets as early as possible.
  The gateway handler is also responsible for the dispatching of gateway packets
  whithin the lorawan worker pool.
  """
  use GenServer
  require Logger
  alias NwkSrv.Storage

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
  1. Verify that only gateways registered in the system can submit packets. Log and drop other packets.
  2. Send the packet to lorawan worker pool (async)
  """
  def handle_call({:receive, packet}, _from, state) do
    in_system = Storage.KV.LoRaWAN.Gateway.lookup_by_eui(packet.gateway.eui)
    if in_system do
      if %LoRaWAN.Gateway.Packet{} = packet do
        NwkSrv.parallel_pool(packet.lorawan, &NwkSrv.Worker.receive/2)
        Storage.KV.LoRaWAN.Gateway.store_meta(packet.gateway)
      end
    else
       Logger.warn "Unregistered gateway #{inspect(packet.gateway.ip)} #{inspect(packet.gateway.eui)}"
    end

    {:reply, {:ok, in_system}, state}
  end
end
