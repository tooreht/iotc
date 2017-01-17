# LoRaWAN

A LoRaWAN protocol library according to the [specification](https://www.lora-alliance.org/portals/0/specs/LoRaWAN%20Specification%201R0.pdf). Implements packet structures of all packet types, encoding, decoding, crypto functions, etc. It is used by both, the network server and the application server component.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `lorawan` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:lorawan, "~> 0.1.0"}]
    end
    ```

  2. Ensure `lorawan` is started before your application:

    ```elixir
    def application do
      [applications: [:lorawan]]
    end
    ```

