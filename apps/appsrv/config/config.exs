# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :appsrv,
  ecto_repos: [Appsrv.Repo]

# Configures the endpoint
config :appsrv, Appsrv.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NTI35mTHIXaPfRS9HjGl2CFujS6q4grWI6PRPiMkoLLfNekgrIU+6m4INENu7CUT",
  render_errors: [view: Appsrv.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Appsrv.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
