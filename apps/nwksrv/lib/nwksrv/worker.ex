 defmodule NwkSrv.Worker do
  @moduledoc """
  This module implements part of the interface between the NwkSrv and AppSrv application.
  """
  use GenServer

  alias NwkSrv.Storage
  alias NwkSrv.Storage.Utils

  require Logger

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

    {mic_check, packet, node} = case packet.mhdr.m_type do
      0x00 -> # Join Request
        # TODO: Don't fetch the app_key in NwkSrv, delegate to AppSrv
        app_key = Utils.get_app_key(packet.mac_payload.app_eui, packet.mac_payload.dev_eui)
        {mic_check, packet} = LoRaWAN.Crypto.valid_mic(:join, {packet, app_key})
        node = Storage.DB.LoRaWAN.Node.get(%{dev_eui: packet.mac_payload.dev_eui})
        {mic_check, packet, node}
      n when n in [0x02, 0x04] -> # Data Up
        nodes = Utils.get_nodes(packet.mac_payload.fhdr.dev_addr, packet.mac_payload.fhdr.f_cnt)
        {mic_check, node} = LoRaWAN.Crypto.valid_mic(:data, {packet, nodes})
        {mic_check, packet, node}
      _ ->
        Logger.warn "no valid m_type"
        {false, nil}
    end

    if mic_check do
      Logger.debug("MIC passed")
    else
      Logger.warn "MIC failed!"
      exit :normal
    end

    LoRaWAN.MACHandler.handle_mac_commands(packet)

    LoRaWAN.Dedup.dedup_packet(packet, node)

    packet = case packet.mhdr.m_type do
      0x00 -> # Join Request
        Logger.warn "OTAA not implemented"
        packet
      n when n in [0x02, 0x04] -> # Unconfirmed Data Up
        AppSrv.LoRaWAN.Handler.receive(AppSrv.LoRaWAN.Handler, packet, node.dev_eui)
        packet
      _ ->
        exit :normal # Should never occur, because the m_type is already checked in MIC check.
    end

    {:reply, packet, state}
  end

end
