# AppSrv

Implements the application component of the LoRaWAN Network Server. It is mainly responsible for the decryption and encryption of LoRaWAN packets and distribution of data to the applications.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `appsrv` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:appsrv, "~> 0.1.0"}]
    end
    ```

  2. Ensure `appsrv` is started before your application:

    ```elixir
    def application do
      [applications: [:appsrv]]
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
