defmodule Appsrv do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Appsrv.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Appsrv.Endpoint, []),
      # Start your own worker by calling: Appsrv.Worker.start_link(arg1, arg2, arg3)
      # worker(Appsrv.Worker, [arg1, arg2, arg3]),
      worker(Appsrv.LoRaWAN.Handler, [Appsrv.LoRaWAN.Handler]),
      # TODO: Add adapters dynamically with configurable options
      worker(Appsrv.Adapters.MQTT, [[name: Appsrv.Adapters.MQTT,
                                     host: "localhost",
                                     reconnect_timeout: 10,
                                     keepalive_interval: 60,
                                     retry_interval: 30]]),
      worker(Appsrv.Adapters.SIOT, [[name: Appsrv.Adapters.SIOT,
                                     host: "localhost",
                                     reconnect_timeout: 10,
                                     keepalive_interval: 60,
                                     retry_interval: 30]]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Appsrv.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Appsrv.Endpoint.config_change(changed, removed)
    :ok
  end
end
