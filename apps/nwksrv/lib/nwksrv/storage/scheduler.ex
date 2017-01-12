defmodule NwkSrv.Storage.Scheduler do
  @moduledoc """
  Simple scheduler for storage tasks.
  """
            
  use GenServer

  alias NwkSrv.Storage

  ## Client API

  @doc """
  Starts the scheduler with the given `name`.
  """
  def start_link(name, opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, Enum.concat(opts, name: name))
  end

  def init(:ok) do
    # Init tasks
    # TODO: More flexible task handling, maybe in config or dynamically

    # Kick of heartbeat
    beats = 0
    if Application.get_env(:nwksrv, NwkSrv.Storage.Scheduler)[:auto_start] do
      Process.send_after(self, :tick, 1000)
    end
    {:ok, {beats}}
  end

  ## Server Callbacks

  def handle_info(:tick, {beats}) do
    Process.send_after(self, :tick, 1000)
    # IO.puts "Executing every second (elapsed #{beats})"
    # Execute tasks
    # TODO: More flexible task handling, maybe in config or dynamically
    cond do
      rem(beats, 10) == 0 -> run_task(&Storage.Tasks.refresh_gateway_euis_from_db/0)
      rem(beats, 10) == 5 -> run_task(&Storage.Tasks.persist_gateways_to_db/0)
      true -> nil
    end
    {:noreply, {beats + 1}}
  end

  defp run_task(task) do
    Task.Supervisor.start_child(NwkSrv.TaskSupervisor, task)
  end
end
