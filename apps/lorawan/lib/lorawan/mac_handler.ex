defmodule LoRaWAN.MACHandler do
  @moduledoc """
    This module handles MAC commands which arrive with packets.
  """
  require Logger

  def handle_mac_commands(packet) do
    if packet.mhdr.m_type > 1 do # it is a Data Message (Join messages do not contain MAC Commands)
      cond do
        packet.mac_payload.fhdr.f_ctrl.f_opts_len > 0 and packet.mac_payload.f_port > 0 ->
          IO.puts "MAC commands in FOpts"
          decode_mac_command(packet.mac_payload.fhdr.f_opts)
        packet.mac_payload.fhdr.f_ctrl.f_opts_len == 0 and packet.mac_payload.f_port == 0 ->
          IO.puts "MAC commands in FRMPayload"
          decode_mac_command(packet.mac_payload.frm_payload)
        packet.mac_payload.fhdr.f_ctrl.f_opts_len == 0 and packet.mac_payload.f_port > 0 ->
          IO.puts "No MAC commands in Packet"
        true ->
          Logger.warn "Malformed packet, mac commands ca be either present in FOpts OR FRMPayload but not in both"
          exit :normal
      end
    end 
  end

  defp decode_mac_command(data) do
    << command::8, rest >> = data
    case command do
      0x02 ->
        IO.puts "MAC: LinkCheckReq"
      0x03 ->
        IO.puts "MAC: LinkADRAns"
      0x04 ->
        IO.puts "MAC: DutyCycleAns"
      0x05 ->
        IO.puts "MAC: RXParamSetupAns"
      0x06 ->
        IO.puts "MAC: DevStatusAns"
      0x07 ->
        IO.puts "MAC: NewChannelAns"
      0x08 ->
        IO.puts "MAC: RXTimingSetupAns"
      n when n in [0x80..0xFF] ->
        IO.puts "MAC: Proprietary"
    end
    # TODO Implement recursion and handling of each command!

  end


end

