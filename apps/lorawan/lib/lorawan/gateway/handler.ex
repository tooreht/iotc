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
  Initializes the handler with the registered `gateway_ids`.
  """
  def init({:ok, gateway_ip}) do
    # Lookup gateway_registry in KV.
    bucket = case KV.Registry.lookup(KV.Registry, "gateway_registry") do
      {:ok, bucket} -> bucket
      :error ->
        KV.Registry.create(KV.Registry, "gateway_registry")
        {:ok, bucket} = KV.Registry.lookup(KV.Registry, "gateway_registry")

        # Fetch list of registered gateway ids from db.
        gateway_ids = [
          "B827EBFFFE7FE413",
          "B827EBFFFE8AA02D",
          "B827EBFFFE8F20E2",
          "B827EBFFFEFF26B2",
          "112BFFDED3",
        ]

        # Store gateway_ids in KV.
        KV.Bucket.put(bucket, "gateway_ids", gateway_ids)
        bucket
    end

    {:ok, {bucket, gateway_ip}}
  end

  @doc """
  Process gateway packets.

  1. Check if the `gateway_id` in the packets is registred in the system.
  2. Send the packet to worker pool (async) if in system else drop the packet and log it.
  """
  def handle_call({:receive, packet}, _from, state) do
    # Verify that the gateway is registered in the system.
    in_system = lookup_gateway(packet.gateway.id, state)
    if in_system do
      if is_list(packet.lorawan) do
        # Send all packets coming from this gateway to the pool.
        LoRaWAN.parallel_pool(packet.lorawan, &LoRaWAN.Worker.receive/2)
      end
      # TODO: Implement storing of statistics
    else
       Logger.warn "Unregistered gateway #{inspect(packet.gateway.ip)} #{inspect(packet.gateway.id)}"
    end

    {:reply, {:ok, in_system}, state}
  end

  ## PRIVATE FUNCTIONS

  defp lookup_gateway(gateway_id, {bucket, _}) do
    gateway_id in KV.Bucket.get(bucket, "gateway_ids")
  end
end
