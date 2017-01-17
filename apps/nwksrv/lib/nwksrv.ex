defmodule NwkSrv do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, NwkSrv.Worker},
      {:size, 8},
      {:max_overflow, 4},
      {:strategy, :lifo}
    ]

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(NwkSrv.Repo, []),
      # Start the endpoint when the application starts
      supervisor(NwkSrv.Endpoint, []),
      # Start the task supervisor
      supervisor(Task.Supervisor, [[name: NwkSrv.TaskSupervisor]]),
      # Start your own worker by calling: NwkSrv.Worker.start_link(arg1, arg2, arg3)
      # worker(NwkSrv.Worker, [arg1, arg2, arg3]),
      :poolboy.child_spec(pool_name(), poolboy_config, []),
      supervisor(NwkSrv.Gateway.Handler.Supervisor, []),
      worker(NwkSrv.Storage.DB, [NwkSrv.Storage.DB]),
      worker(NwkSrv.Storage.Scheduler, [NwkSrv.Storage.Scheduler])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NwkSrv.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NwkSrv.Endpoint.config_change(changed, removed)
    :ok
  end

  # LoRaWAN Worker Pool
  def parallel_pool(pkts, f) do
    Enum.each(
      pkts,
      fn(pkt) -> spawn( fn() -> hit_the_pool_boy(pkt, f) end ) end
    )
  end

  defp pool_name() do
    :lorawan_pool
  end

  defp hit_the_pool_boy(pkt, f) do
    :poolboy.transaction(
      pool_name(),
      fn(pid) -> f.(pid, pkt) end,
      42_000
    )
  end
end
