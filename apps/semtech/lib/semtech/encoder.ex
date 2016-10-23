defmodule Semtech.Encoder do
  @moduledoc """
  This module is responsible for the encoding of the different packet types.
  """

  @doc """
  Encodes a packet to it's binary format based on the identifier.
  """
  def encode(packet) do
    case packet.identifier do
      0x00 -> <<
          packet.version    :: size(8),
          packet.token      :: size(16),
          0x00              :: size(8),
          packet.gateway_id :: size(64),
          packet.payload    :: binary
        >>
      0x01 -> <<
          packet.version    :: size(8),
          packet.token      :: size(16),
          0x01              :: size(8)
        >>
      0x02 -> <<
          packet.version    :: size(8),
          packet.token      :: size(16),
          0x02              :: size(8),
          packet.gateway_id :: size(64)
        >>
      0x03 -> <<
          packet.version    :: size(8),
          packet.token      :: size(16),
          0x03              :: size(8),
          packet.payload    :: binary
        >>
      0x04 -> <<
          packet.version    :: size(8),
          packet.token      :: size(16),
          0x04              :: size(8)
        >>
      0x05 -> <<
          packet.version    :: size(8),
          packet.token      :: size(16),
          0x05              :: size(8),
          packet.payload    :: binary
        >>
      _ -> nil
    end
  end
end
