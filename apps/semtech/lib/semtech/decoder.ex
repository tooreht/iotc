defmodule Semtech.Decoder do

  def parse_pkt_fwd_packet(<<
      version     :: size(8),
      token       :: size(16),
      identifier  :: size(8),
      gateway_id  :: size(64),
      payload     :: binary
    >>) do

    IO.puts payload
    # PUSH_DATA packet
    %Semtech.Packet{
      version: version,
      token: token,
      identifier: identifier,
      gateway_id: gateway_id,
      payload: Poison.decode!(payload, as: %Semtech.RXPK{
        rxpk: [%Semtech.RXPK.Item{}]
      })
    }
  end
end
