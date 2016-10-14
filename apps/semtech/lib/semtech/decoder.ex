defmodule Semtech.Decoder do

  def parse_pkt_fwd_packet(data) do
    packet_len = length(data)
    IO.puts packet_len
    reminder_size = packet_len * 8 - 32
    IO.puts reminder_size

    # <<
    #   version       :: size(8),
    #   random_token  :: size(16),
    #   type          :: size(8),
    #   reminder      :: size(reminder_size)
    # >> = data

    # case 0x00 do
    #   ^type -> parse_push_data(version, random_token, type, reminder)
    # end
  end

  def parse_push_data(version, random_token, type, reminder) do
    IO.puts inspect({version, random_token, type, reminder})
  end
end
