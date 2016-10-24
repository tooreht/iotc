 defmodule Handler do
  @moduledoc """
  This module implements the LoRaWAN communication protocol between LoRa mote and server.
  """
  use GenServer
  require Logger

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, [name: name])
  end

  def handle_call(payload, _from, nil) do
    phy_payload = parse_packet(payload)

    {:reply, "Packed handled", nil}
  end

  @doc """
  Multi-clause function to parse packets depending on their MHDR and Major.

  """
  defp parse_packet(<<
    0x00    :: size(3), # MType Join Request
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do 

    payload_size = bit_size(data) - 32
    Logger.info "this is a Join Request Packet"

    <<
      payload ::  size(payload_size), 
      mic     ::  size(32)
    >> = data
    
    %LoRaWAN.JoinRequest{
      payload: payload,
      mic: mic
    }
  end

  defp parse_packet(<<
    0x02    :: size(3), # MType Unconfirmed Data Up
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do

    payload_size = bit_size(data) - 32
    Logger.info "this is an Unconfirmed Data Up Packet"

    <<
      payload ::  size(payload_size), 
      mic     ::  size(32)
    >> = data
    
    %LoRaWAN.UnconfirmedDataUp{
      payload: payload,
      mic: mic
    }
  end

  defp parse_packet(<<
    0x04    :: size(3), # MType Confirmed Data Up
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do 

    payload_size = bit_size(data) - 32
    Logger.info "this is an Confirmed Data Up Packet"

    <<
      payload ::  size(payload_size),
      mic     ::  size(32)
    >> = data

    %LoRaWAN.ConfirmedDataUp{
      payload: payload,
      mic: mic
    }
  end

  defp parse_packet(<<
    0x07    :: size(3), # MType Proprietary
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do

    payload_size = bit_size(data) - 32
    Logger.info "this is a Proprietary Packet"

    <<
      payload ::  size(payload_size),
      mic     ::  size(32)
    >> = data

    %LoRaWAN.Proprietary{
      payload: payload,
      mic: mic
    }
  end
end
