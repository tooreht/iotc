defmodule Semtech.Decoder do
  @moduledoc """
  This module implements the basic communication protocol between Lora gateway and server.

  ## References:
    * [Protocol](https://github.com/Lora-net/packet_forwarder/blob/master/PROTOCOL.TXT)
  """


  @doc """
  Multi-clause function to parse packets depending on their size and identifier.

  Identifiers:

       Identifier  | Hex
      :-----------:|------
       PUSH_DATA   | 0x00
       PUSH_ACK    | 0x01
       PULL_DATA   | 0x02
       PULL_ACK    | 0x04
       PULL_RESP   | 0x03
       TX_ACK      | 0x05


  ## PUSH_DATA packet (0x00)

  That packet type is used by the gateway mainly to forward the RF packets
  received, and associated metadata, to the server.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | random token
       3      | PUSH_DATA identifier 0x00
       4-11   | Gateway unique identifier (MAC address)
       12-end | JSON object, starting with {, ending with }


  ## PUSH_ACK packet (0x01)

  That packet type is used by the server to acknowledge immediately all the
  PUSH_DATA packets received.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | same token as the PUSH_DATA packet to acknowledge
       3      | PUSH_ACK identifier 0x01


  ## PULL_DATA packet (0x02)

  That packet type is used by the gateway to poll data from the server.

  This data exchange is initialized by the gateway because it might be
  impossible for the server to send packets to the gateway if the gateway is
  behind a NAT.

  When the gateway initialize the exchange, the network route towards the
  server will open and will allow for packets to flow both directions.
  The gateway must periodically send PULL_DATA packets to be sure the network
  route stays open for the server to be used at any time.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | random token
       3      | PULL_DATA identifier 0x02
       4-11   | Gateway unique identifier (MAC address)


  ## PULL_ACK packet (0x04)

      That packet type is used by the server to confirm that the network route is
      open and that the server can send PULL_RESP packets at any time.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | same token as the PULL_DATA packet to acknowledge
       3      | PULL_ACK identifier 0x04


  ## PULL_RESP packet (0x03)

      That packet type is used by the server to send RF packets and associated
      metadata that will have to be emitted by the gateway.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | random token
       3      | PULL_RESP identifier 0x03
       4-end  | JSON object, starting with {, ending with }


  ## TX_ACK packet (0x05)

  That packet type is used by the gateway to send a feedback to the server
  to inform if a downlink request has been accepted or rejected by the gateway.
  The datagram may optionnaly contain a JSON string to give more details on
  acknoledge. If no JSON is present (empty string), this means than no error
  occured.

       Bytes  | Function
      :------:|---------------------------------------------------------------------
       0      | protocol version = 2
       1-2    | same token as the PULL_RESP packet to acknowledge
       3      | TX_ACK identifier 0x05
       4-end  | [optional] JSON object, starting with {, ending with }


  ## Default clause for unknown packets

  Return `:error` with error message `:unknown_pkt_fwd_packet` and unknown packet as binary data.
  """
  def parse_pkt_fwd_packet(<<
      version     :: size(8),
      token       :: size(16),
      0x00        :: size(8),
      gateway_id  :: size(64),
      payload     :: binary
    >>) do

    %Semtech.PushData{
      version: version,
      token: token,
      identifier: 0x00,
      gateway_id: Integer.to_char_list(gateway_id, 16),
      payload: Poison.decode!(payload, as: 
        %Semtech.PushData.RxPk{
          rxpk: [%Semtech.PushData.RxPk.Item{}],
          stat: %Semtech.PushData.RxPk.Status{}
        }
      )
    }
  end

  def parse_pkt_fwd_packet(<<
      version     :: size(8),
      token       :: size(16),
      0x01        :: size(8)
    >>) do

    %Semtech.PushAck{
      version: version,
      token: token,
      identifier: 0x01
    }
  end

  def parse_pkt_fwd_packet(<<
      version     :: size(8),
      token       :: size(16),
      0x02        :: size(8),
      gateway_id  :: size(64)
    >>) do

    %Semtech.PullData{
      version: version,
      token: token,
      identifier: 0x02,
      gateway_id: Integer.to_char_list(gateway_id, 16)
    }
  end

  def parse_pkt_fwd_packet(<<
      version     :: size(8),
      token       :: size(16),
      0x04        :: size(8)
    >>) do

    %Semtech.PullAck{
      version: version,
      token: token,
      identifier: 0x04
    }
  end

  def parse_pkt_fwd_packet(<<
      version     :: size(8),
      token       :: size(16),
      0x03        :: size(8),
      payload     :: binary
    >>) do

    %Semtech.PullResp{
      version: version,
      token: token,
      identifier: 0x03,
      payload: Poison.decode!(payload, as: %Semtech.PullResp.TxPk{})
    }
  end

  def parse_pkt_fwd_packet(<<
      version     :: size(8),
      token       :: size(16),
      0x05        :: size(8),
      payload     :: binary
    >>) do

    %Semtech.TxAck{
      version: version,
      token: token,
      identifier: 0x05,
      payload: Poison.decode!(payload, as: %Semtech.TxAck.TxPk{})
    }
  end

  def parse_pkt_fwd_packet(unknown) do
    {:error, {:unknown_pkt_fwd_packet, unknown}}
  end
end
