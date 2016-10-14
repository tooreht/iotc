defmodule Semtech do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Receiver, [])
    ]

    # Start the main supervisor, and restart failed children individually
    opts = [strategy: :one_for_one, name: Semtech.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
