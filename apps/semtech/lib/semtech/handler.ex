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
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Receive up the client pid for `client_id` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def send(server, {socket, ip, port}, data) do
    GenServer.call(server, {:send, {socket, ip, port}, data})
  end

  @doc """
  Receive up the client pid for `client_id` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def receive(server, {socket, ip, port}, data) do
    GenServer.call(server, {:receive, {socket, ip, port}, data})
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:send, {socket, ip, port}, data}, _from, state) do
    UDP.Server.tx(UDP.Server, {socket, ip, port}, data)
    {:reply, data, state}
  end

  def handle_call({:receive, {socket, ip, port}, data}, _from, state) do
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

        # Process packets after ack.
        # TODO: Implement!


        UDP.Server.tx(UDP.Server, {socket, ip, port}, data)
        {:reply, data, state}
      0x02 -> 
        # Acknowledge immediately all the PullData packets received with a PullAck packet.
        tx_packet = %Semtech.PullAck{
          version: rx_packet.version,
          token: rx_packet.token,
        }
        Logger.debug "Sent packet: " <> inspect(tx_packet)
        data = encode(tx_packet)

        UDP.Server.tx(UDP.Server, {socket, ip, port}, data)
        {:reply, data, state}
      _ -> {:reply, data, state}
    end
  end
end
