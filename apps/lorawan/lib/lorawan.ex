defmodule LoRaWAN do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    # Start the main supervisor, and restart failed children individually
    opts = [strategy: :one_for_one, name: LoRaWAN.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
