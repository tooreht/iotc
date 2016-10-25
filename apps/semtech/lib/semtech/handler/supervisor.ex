defmodule Semtech.Handler.Supervisor do
  @moduledoc """
  This module supervises handlers.
  """
  use Supervisor

  # A simple module attribute that stores the supervisor name
  @name Semtech.Handler.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_handler(gateway_ip) do
    Supervisor.start_child(@name, [gateway_ip])
  end

  def init(:ok) do
    children = [
      worker(Semtech.Handler, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
