defmodule Semtech.Handler do
  @moduledoc """
  This module handels Semtech packets.
  """
  use GenServer
  require Logger

  ## Client API

  @doc """
  Starts the registry with the given `name`.
  """
  def start_link(gateway_ip, opts \\ []) do
    GenServer.start_link(__MODULE__, {:ok, gateway_ip}, opts)
  end

  @doc """
  Receive up the client pid for `client_id` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def send(server, {socket, gateway_ip, port}, data) do
    GenServer.call(server, {:send, {socket, gateway_ip, port}, data})
  end

  @doc """
  Receive up the client pid for `client_id` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def receive(server, {socket, gateway_ip, port}, data) do
    GenServer.cast(server, {:receive, {socket, gateway_ip, port}, data})
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  ## Server Callbacks

  def init({:ok, gateway_ip}) do
    {:ok, _} = KV.Registry.create(KV.Registry, gateway_ip)
    {:ok, bucket} = KV.Registry.lookup(KV.Registry, gateway_ip)
    KV.Bucket.put(bucket, "stats", [])
    {:ok, %{gateway_ip: gateway_ip, bucket: bucket}}
  end

  def handle_call({:send, {socket, gateway_ip, port}, data}, _from, state) do
    UDP.Server.send(UDP.Server, {socket, gateway_ip, port}, data)
    {:reply, data, state}
  end

  def handle_cast({:receive, {socket, gateway_ip, port}, data}, state) do
    import Semtech.Encoder
    import Semtech.Decoder

    # Decode the packet received from the gateway
    rx_packet = decode(data)
    Logger.debug "Received packet: " <> inspect(rx_packet)

    case rx_packet.identifier do
      0x00 -> 
        # Acknowledge immediately all the PushData packets received with a PushAck packet.
        tx_packet = %Semtech.PushAck{
          version: rx_packet.version,
          token: rx_packet.token,
        }
        Logger.debug "Sent packet: " <> inspect(tx_packet)
        data = encode(tx_packet)

        UDP.Server.send(UDP.Server, {socket, gateway_ip, port}, data)
        
        # Further packet processing after ack.

        # Store stats data in bucket
        if rx_packet.payload.stat !== nil do
          stats = KV.Bucket.get(state.bucket, "stats")
          KV.Bucket.put(state.bucket, "stats", [rx_packet.payload.stat | stats])
        end

        if rx_packet.payload.rxpk !== [] do
          LoRaWAN.Handler.receive(LoRaWAN.Handler, {socket, gateway_ip, port}, rx_packet.payload.rxpk)
        end

        {:noreply, state}
      0x02 -> 
        # Acknowledge immediately all the PullData packets received with a PullAck packet.
        tx_packet = %Semtech.PullAck{
          version: rx_packet.version,
          token: rx_packet.token,
        }
        Logger.debug "Sent packet: " <> inspect(tx_packet)
        data = encode(tx_packet)

        UDP.Server.send(UDP.Server, {socket, gateway_ip, port}, data)
        {:noreply, state}
      _ -> {:noreply, state}
    end
  end
end
