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

# Configures the Storage API
config :appsrv, :core_api, Core.Storage.DB

# Configures the available adapters
config :appsrv, Appsrv.Adapters,
  [Appsrv.Adapters.MQTT,
   Appsrv.Adapters.SIOT]

# Configures the MQTT adapter
config :appsrv, Appsrv.Adapters.MQTT,
  connection: [
    name: Appsrv.Adapters.MQTT,
    host: "localhost",
    reconnect_timeout: 10,
    keepalive_interval: 60,
    retry_interval: 30
  ]

# Configures the SIOT adapter
config :appsrv, Appsrv.Adapters.SIOT,
  connection: [
    name: Appsrv.Adapters.SIOT,
    host: "siot.net",
    reconnect_timeout: 10,
    keepalive_interval: 60,
    retry_interval: 30
  ],
  licence: "9A8A-BC30-D22B-4F9B-BF39-927C-008B-15EA"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :xain, :after_callback, {Phoenix.HTML, :raw}

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Appsrv.User,
  repo: Appsrv.Repo,
  module: Appsrv,
  logged_out_url: "/",
  email_from_name: "tooreht",
  email_from_email: "tooreht@gmail.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable]

config :coherence, Appsrv.Coherence.Mailer,
  adapter: Swoosh.Adapters.Local
  # api_key: "your api key here"
# %% End Coherence Configuration %%

config :ex_admin,
  repo: Appsrv.Repo,
  module: Appsrv,
  modules: [
    Appsrv.ExAdmin.Dashboard,
    Appsrv.ExAdmin.User,
    Appsrv.ExAdmin.LoRaWAN.Application,
    Appsrv.ExAdmin.LoRaWAN.Node,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
