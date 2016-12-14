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

  def handle_call({:receive, frame}, _from, state) do
    # :timer.sleep(1000)

    # Decode Paket
    data = Base.decode64!(frame.payload)
    Logger.info "Received data: #{inspect(data)}"
    packet = LoRaWAN.Decoder.decode(data)

    Logger.info "Received Packet: #{inspect(packet)}"

    if LoRaWAN.Crypto.valid_mic?(packet) do
      IO.puts("MIC passed!")
    else
      Logger.warn "MIC failed!"
    end
    
    {:reply, packet, state}
  end

end
