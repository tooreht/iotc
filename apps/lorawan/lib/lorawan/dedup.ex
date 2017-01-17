defmodule LoRaWAN.Dedup do
  @moduledoc """
  This module deduplicates LoRaWAN packets.
  """
  require Logger

  def dedup_packet(packet, node) do
    case packet.mhdr.m_type do
      n when n in [0, 1] ->
        dedup_join_packet(packet, node)
      n when n in [2, 3, 4, 5] ->
        dedup_data_packet(packet, node)
      6 ->
        dedup_proprietary_packet(packet, node)
      _ ->
        Logger.warn "Received packet with MType not defined -> Drop"
        exit :normal
    end
  end

  defp dedup_join_packet(packet, node) do
    meta = %{}
    packet_id = exists_this_join_packet(packet.mac_payload.dev_eui, packet.mac_payload.dev_nonce)
    if packet_id > 0 do
      store_packet_meta(packet_id, meta)
      Logger.info "Duplicate Join from " <> packet.mac_payload.dev_eui
      exit :normal
    end
    packet_id = store_packet(packet)
    store_packet_meta(packet_id, meta)
  end

  defp dedup_data_packet(packet, node) do
    meta = %{}
    packet_id = exists_this_data_packet(node.dev_eui, packet.mac_payload.fhdr.f_cnt)
    if packet_id > 0 do
      store_packet_meta(packet_id, meta)
      Logger.info "Duplicate Data packet from " <> node.dev_eui <> " with number " <> packet.mac_payload.fhdr.f_cnt
      exit :normal
    end
    packet_id = store_packet(packet)
    store_packet_meta(packet_id, meta)
  end

   defp dedup_proprietary_packet(packet, node) do
     # TODO Implement
     0
   end

  defp exists_this_join_packet(dev_eui, dev_nonce) do
    # TODO Implement
    0
  end

  defp exists_this_data_packet(dev_eui, f_cnt) do
    # TODO Implement
    0
  end

  defp store_packet(packet) do
    # TODO Implement

  end

  defp store_packet_meta(packet_id, meta) do
    # TODO Implement

  end
end
