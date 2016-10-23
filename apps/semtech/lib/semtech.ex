defmodule Semtech do
  @moduledoc """
  This module implements the Semtech basic communication protocol between LoraWAN gateway and server
  as described [here](https://github.com/Lora-net/packet_forwarder/blob/master/PROTOCOL.TXT).
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    udp_host = Application.get_env(:semtech, :UDP_HOST)
    udp_port = Application.get_env(:semtech, :UDP_PORT)

    server_settings = %{
      host: udp_host,
      port: udp_port
    }

    children = [
      worker(UDP.Server, [server_settings, [name: UDP.Server]]),
      supervisor(Semtech.Handler.Supervisor, [])
    ]

    # Start the main supervisor, and restart failed children individually
    opts = [strategy: :one_for_one, name: Semtech.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
