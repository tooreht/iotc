defmodule Receiver do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, _socket} = :gen_udp.open(1700)
  end

  def handle_info({:udp, _socket, _ip, _port, data}, state) do
    import Semtech.Decoder
    IO.puts inspect(data)
    parse_pkt_fwd_packet(data)
    {:noreply, state}
  end

  def handle_info({_, _socket}, state) do
    {:noreply, state}
  end
end
