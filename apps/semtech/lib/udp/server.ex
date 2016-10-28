defmodule UDP.Server do
  @moduledoc """
  This module dispatches UDP packets.
  """
  use GenServer
  alias Core.Config
  require Logger

  ## Client API

  @doc """
  Starts the UDP server.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Send UDP datagrams.
  """
  def send(server, {socket, ip, port}, data) do
    GenServer.cast(server, {:send, {socket, ip, port}, data})
  end

  ## Server Callbacks

  def init(:ok) do
    handlers = %{}
    refs = %{}

    ip = Config.get_ip(:semtech, :udp_host, {0,0,0,0})
    port = Config.get_integer(:semtech, :udp_port, 1700)

    {:ok, socket} = :gen_udp.open(port, [:binary, :inet,
                                               {:ip, ip},
                                               {:active, true}])
    Logger.debug("UDP server listening on #{:inet_parse.ntoa(ip)}:#{port}")
    {:ok, {socket, handlers, refs}}
  end

  def handle_cast({:send, {socket, ip, port}, data}, state) do
    :ok = :gen_udp.send(socket, ip, port, data)
    {:noreply, state}
  end

  def handle_info({:udp, socket, ip, port, data}, {socket, handlers, refs}) do
    result = Map.fetch(handlers, ip)
    {handler, handlers, refs} = case result do
      {:ok, handler} -> {handler, handlers, refs}
      :error ->
        {:ok, handler} = Semtech.Handler.Supervisor.start_handler(ip)
        ref = Process.monitor(handler)
        refs = Map.put(refs, ref, ip)
        handlers = Map.put(handlers, ip, handler)
        
        {handler, handlers, refs}
    end
    
    Semtech.Handler.receive(handler, {socket, ip, port}, data)

    {:noreply, {socket, handlers, refs}}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {socket, handlers, refs}) do
    {ip, refs} = Map.pop(refs, ref)
    handlers = Map.delete(handlers, ip)
    {:noreply, {socket, handlers, refs}}
  end

  def handle_info({:udp, _socket}, state) do
    {:noreply, state}
  end

  def handle_info({:udp_passive, _socket}, state) do
    {:noreply, state}
  end
end
