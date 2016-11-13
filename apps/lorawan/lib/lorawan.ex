defmodule LoRaWAN do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, LoRaWAN.Worker},
      {:size, 8},
      {:max_overflow, 4},
      {:strategy, :lifo}
    ]

    children = [
      supervisor(LoRaWAN.Gateway.Handler.Supervisor, []),
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    # Start the main supervisor, and restart failed children individually
    opts = [strategy: :one_for_one, name: LoRaWAN.Supervisor]
    Supervisor.start_link(children, opts)
  end

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
