defmodule KV.Supervisor do
  @moduledoc """
  This module supervises the key-value store.
  """
  use Supervisor

  # A simple module attribute that stores the supervisor name
  @name KV.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(KV.Registry, [KV.Registry]),
      supervisor(KV.Bucket.Supervisor, [])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
