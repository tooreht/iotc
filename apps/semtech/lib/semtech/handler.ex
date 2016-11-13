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
    {:ok, handler} = LoRaWAN.Gateway.Handler.Supervisor.start_handler(gateway_ip)
    ref = Process.monitor(handler)

    {:ok, {handler, ref, gateway_ip}}
  end

  def handle_call({:send, {socket, gateway_ip, port}, data}, _from, state) do
    UDP.Server.send(UDP.Server, {socket, gateway_ip, port}, data)
    {:reply, data, state}
  end

  def handle_cast({:receive, {socket, gateway_ip, port}, data}, state = {handler, _, _}) do
    import Semtech.Encoder
    import Semtech.Decoder

    # Decode the packet received from the gateway.
    rx_packet = decode(data)
    Logger.debug "Received packet: #{inspect(rx_packet)}from #{inspect(gateway_ip)}:#{inspect(port)}"

    # Harmonize Semtech packet to internal format.
    packet = Semtech.Harmonizer.harmonize(gateway_ip, rx_packet)

    # Let the gateway handler validate the packet.
    response = LoRaWAN.Gateway.Handler.receive(handler, packet)

    case response do
      {:ok, true} ->
        case rx_packet.identifier do
          0x00 ->
            tx_packet = %Semtech.PushAck{
              version: rx_packet.version,
              token: rx_packet.token,
            }
            Logger.debug "Sent packet: #{inspect(tx_packet)}to #{inspect(gateway_ip)}:#{inspect(port)}"
            # Ecode the PushAck packet
            data = encode(tx_packet)
            # Send ack if the packet is accepted by the gateway handler.
            UDP.Server.send(UDP.Server, {socket, gateway_ip, port}, data)
            {:noreply, state}
          0x02 ->
            # Acknowledge immediately all the PullData packets received with a PullAck packet.
            tx_packet = %Semtech.PullAck{
              version: rx_packet.version,
              token: rx_packet.token,
            }
            Logger.debug "Sent packet: #{inspect(tx_packet)}to #{inspect(gateway_ip)}:#{inspect(port)}"
            data = encode(tx_packet)
            UDP.Server.send(UDP.Server, {socket, gateway_ip, port}, data)
            {:noreply, state}
          _ -> {:noreply, state}
        end
      _ ->
        Logger.warn "Drop packet: #{inspect(rx_packet)}from #{inspect(gateway_ip)}:#{inspect(port)}"
        {:noreply, state}
    end
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    Process.exit(self(), :normal)
    {:noreply, state}
  end
end
