# NwkSrv

Implements the network component of the LoRaWAN Network Server. Abstracts away most of the LoRaWAN protocol without the decryption and encryption part. So it is responsible for the communication to the nodes over gateways, implements the MAC layer of the LoRaWAN protocol and routes the still encrypted payload to the application component(s).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `nwksrv` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:nwksrv, "~> 0.1.0"}]
    end
    ```

  2. Ensure `nwksrv` is started before your application:

    ```elixir
    def application do
      [applications: [:nwksrv]]
    end
    ```

## Phoenix

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
