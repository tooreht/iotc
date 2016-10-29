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
    packet = parse_packet(payload)

    Logger.debug "Received Packet: " <> inspect(packet)

    {:reply, packet, nil}
  end

  defp parse_packet(<<
    0x00    :: size(3), # MType Join Request
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do 
    alias LoRaWAN.JoinRequest, as: JR

    payload_size = byte_size(data) - 4
    <<
      payload ::  bytes-size(payload_size), 
      mic     ::  bytes-size(4)
    >> = data

    <<
      appEUI    :: little-size(1)-unit(64),
      devEUI    :: little-size(1)-unit(64),
      devNonce  :: little-size(1)-unit(16)
    >> = payload
    
    %JR{
      payload: %JR.MACPayload{
          appEUI: << appEUI :: size(8)-unit(8) >>,
          devEUI: << devEUI :: size(8)-unit(8) >>,
          devNonce: << devNonce :: size(2)-unit(8) >>  
        },
      mic: mic
    }
  end

  defp parse_packet(<<
    0x02    :: size(3), # MType Unconfirmed Data Up
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do
    alias LoRaWAN.UnconfirmedDataUp, as: UDU

    payload_size = byte_size(data) - 4
    <<
      payload ::  bytes-size(payload_size), 
      mic     ::  bytes-size(4)
    >> = data

    <<
      devIntAddr :: little-size(1)-unit(32), 
      adr        :: size(1),
      adrAckReq  :: size(1),
      ack        :: size(1),
      rfu        :: size(1),
      fOptsLen   :: size(4),
      fCnt       :: little-size(1)-unit(16),
      fOpts      :: bytes-size(fOptsLen),
      fPort      :: bytes-size(1),
      dataFrame  :: binary 
    >> = payload
    
    %UDU{
      payload: %UDU.MACPayload{
        devAddr: << devIntAddr :: size(4)-unit(8) >>, # HACK to get a binary and not an int
        fCtrl: %UDU.MACPayload.FCtrl {
            adr: adr,
            adrAckReq: adrAckReq,
            ack: ack,
            rfu: rfu,
            fOptsLen: fOptsLen
          },        
          fCnt: fCnt,
          fOpts: fOpts,
          fPort: fPort,
          frmPayload: dataFrame
        },
      mic: mic
    }
  end

  defp parse_packet(<<
    0x04    :: size(3), # MType Confirmed Data Up
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do
    alias LoRaWAN.ConfirmedDataUp, as: CDU 

    payload_size = byte_size(data) - 4
    <<
      payload ::  bytes-size(payload_size), 
      mic     ::  bytes-size(4)
    >> = data

    <<
      devIntAddr :: little-size(1)-unit(32), 
      adr        :: size(1),
      adrAckReq  :: size(1),
      ack        :: size(1),
      rfu        :: size(1),
      fOptsLen   :: size(4),
      fCnt       :: little-size(1)-unit(16),
      fOpts      :: bytes-size(fOptsLen),
      fPort      :: bytes-size(1),
      dataFrame  :: binary 
    >> = payload
    
    %CDU{
      payload: %CDU.MACPayload{
        devAddr: << devIntAddr :: size(4)-unit(8) >>, # HACK to get a binary and not an int
        fCtrl: %CDU.MACPayload.FCtrl {
            adr: adr,
            adrAckReq: adrAckReq,
            ack: ack,
            rfu: rfu,
            fOptsLen: fOptsLen
          },        
          fCnt: fCnt,
          fOpts: fOpts,
          fPort: fPort,
          frmPayload: dataFrame
        },
      mic: mic
    }
  end

  defp parse_packet(<<
    0x07    :: size(3), # MType Proprietary
    0x00    :: size(3), # RFU
    0x00    :: size(2), # Major (0 = 1.0)
    data    :: binary
    >>) do
    alias LoRaWAN.Proprietary, as: PPY

    payload_size = byte_size(data) - 4
    <<
      payload ::  bytes-size(payload_size), 
      mic     ::  bytes-size(4)
    >> = data
    
    %PPY{
      payload: payload,
      mic: mic
    }
  end
end
