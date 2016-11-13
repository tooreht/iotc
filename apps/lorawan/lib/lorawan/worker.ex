 defmodule LoRaWAN.Worker do
  @moduledoc """
  This module implements the LoRaWAN communication protocol between LoRa mote and server.
  """
  use GenServer
  require Logger

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def receive(pid, packet) do
    GenServer.call(pid, {:receive, packet})
  end

  ## Server Callbacks

  def handle_call({:receive, packet}, _from, state) do
    # :timer.sleep(1000)

    data = Base.decode64!(packet.payload)
    phy_payload = LoRaWAN.Decoder.decode(data)

    Logger.debug "Received Packet: #{inspect(phy_payload)}"

    {:reply, phy_payload, state}
  end
end
