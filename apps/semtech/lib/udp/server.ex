defmodule UDP.Server do
  @moduledoc """
  This module dispatches UDP packets.
  """
  use GenServer
  require Logger

  ## Client API

  @doc """
  Starts the UDP server.
  """
  def start_link(settings, opts \\ []) do
    GenServer.start_link(__MODULE__, settings, opts)
  end

  @doc """
  Transmit UDP datagrams.
  """
  def tx(server, {socket, ip, port}, data) do
    GenServer.cast(server, {:tx, {socket, ip, port}, data})
  end

  ## Server Callbacks

  def init(settings) do
    handlers = %{}
    refs = %{}
    {:ok, socket} = :gen_udp.open(settings.port, [:binary, :inet,
                                               {:ip, settings.host},
                                               {:active, true}])
    Logger.debug("Listening on #{:inet_parse.ntoa(settings.host)}:#{settings.port}")
    {:ok, {socket, handlers, refs}}
  end

  def handle_cast({:tx, {socket, ip, port}, data}, state) do
    :ok = :gen_udp.send(socket, ip, port, data)
    {:noreply, state}
  end

  def handle_info({:udp, socket, ip, port, data}, {socket, handlers, refs}) do
    {:ok, _} = KV.Registry.create(KV.Registry, ip)
    
    result = Map.fetch(handlers, ip)
    {handler, handlers, refs} = case result do
      {:ok, handler} -> {handler, handlers, refs}
      :error ->
        # {:ok, bucket} = KV.Registry.lookup(registry, ip)
        # KV.Bucket.put(bucket, "clients", %{socket, ip, port})

        {:ok, handler} = Semtech.Handler.Supervisor.start_handler
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
