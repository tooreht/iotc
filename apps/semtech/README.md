# Semtech

This module implements the Semtech basic communication protocol between LoRaWAN gateway and server as described [here](https://github.com/Lora-net/packet_forwarder/blob/master/PROTOCOL.TXT).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `semtech` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:semtech, "~> 0.1.0"}]
    end
    ```

  2. Ensure `semtech` is started before your application:

    ```elixir
    def application do
      [applications: [:semtech]]
    end
    ```

