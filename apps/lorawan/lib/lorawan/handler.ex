 defmodule LoRaWAN.Handler do
  @moduledoc """
  This module implements the LoRaWAN communication protocol between LoRa mote and server.
  """
  use GenServer
  require Logger

  ## Client API

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, [name: name])
  end

  def receive(server, {socket, gateway_ip, port}, rxpks) do
    # Iterate over all packets coming from this UDP message from a gateway.
    for rxpk <- rxpks do
      data = Base.decode64!(rxpk.data)
      GenServer.call(server, {:receive, {socket, gateway_ip, port}, data})
    end
  end

  ## Server Callbacks

  def handle_call({:receive, {_socket, gateway_ip, _port}, data}, _from, state) do
    packet = LoRaWAN.Decoder.decode(data)

    Logger.debug "Received Packet: #{inspect(packet)} from #{inspect(gateway_ip)}"

    {:reply, packet, state}
  end
end
