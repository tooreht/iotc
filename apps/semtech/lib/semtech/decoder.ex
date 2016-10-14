defmodule Semtech.Decoder do

  def parse_pkt_fwd_packet(<<
      version       :: size(8),
      random_token  :: size(16),
      type          :: size(8),
      mac           :: size(64),
      json          :: binary
    >>) do
    IO.puts version
    IO.puts random_token
    IO.puts type
    IO.puts mac
    IO.puts json
  end

  def parse_push_data(version, random_token, type, reminder) do
    IO.puts inspect({version, random_token, type, reminder})
  end
end
