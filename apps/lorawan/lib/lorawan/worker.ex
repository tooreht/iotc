 defmodule LoRaWAN.Worker do
  @moduledoc """
  This module implements the LoRaWAN communication protocol between LoRa mote and server.
  """
  use GenServer
  require Logger
  alias Core.Storage

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def receive(pid, packet) do
    GenServer.call(pid, {:receive, packet})
  end

  ## Server Callbacks

  def handle_call({:receive, data}, _from, state) do
    # :timer.sleep(1000)

    # Decode Paket
    raw = Base.decode64!(data.payload)
    Logger.info "Received raw: #{inspect(raw)}"
    packet = LoRaWAN.Decoder.decode(raw)

    Logger.info "Received Packet: #{inspect(packet)}"

    {mic_check, node} = LoRaWAN.Crypto.valid_mic(packet)
    if mic_check do
      Logger.debug("MIC passed")
    else
      Logger.warn "MIC failed!"
      exit :normal
    end

    LoRaWAN.MACHandler.handle_mac_commands(packet)

    LoRaWAN.Dedup.dedup_packet(packet, node)

    Appsrv.LoRaWAN.Handler.receive(Appsrv.LoRaWAN.Handler, packet, node.dev_eui)
    
    {:reply, packet, state}
  end

end
