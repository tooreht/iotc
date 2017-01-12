# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :appsrv,
  ecto_repos: [AppSrv.Repo]

# Configures the endpoint
config :appsrv, AppSrv.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NTI35mTHIXaPfRS9HjGl2CFujS6q4grWI6PRPiMkoLLfNekgrIU+6m4INENu7CUT",
  render_errors: [view: AppSrv.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AppSrv.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures the Storage API
config :appsrv, :nwksrv_api, NwkSrv.Storage.DB

# Configures the available adapters
config :appsrv, AppSrv.Adapters,
  [AppSrv.Adapters.MQTT,
   AppSrv.Adapters.SIOT]

# Configures the MQTT adapter
config :appsrv, AppSrv.Adapters.MQTT,
  connection: [
    name: AppSrv.Adapters.MQTT,
    host: "localhost",
    reconnect_timeout: 10,
    keepalive_interval: 60,
    retry_interval: 30
  ]

# Configures the SIOT adapter
config :appsrv, AppSrv.Adapters.SIOT,
  connection: [
    name: AppSrv.Adapters.SIOT,
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
  user_schema: AppSrv.User,
  repo: AppSrv.Repo,
  module: AppSrv,
  logged_out_url: "/",
  email_from_name: "tooreht",
  email_from_email: "tooreht@gmail.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable]

config :coherence, AppSrv.Coherence.Mailer,
  adapter: Swoosh.Adapters.Local
  # api_key: "your api key here"
# %% End Coherence Configuration %%

config :ex_admin,
  repo: AppSrv.Repo,
  module: AppSrv,
  modules: [
    AppSrv.ExAdmin.Dashboard,
    AppSrv.ExAdmin.User,
    AppSrv.ExAdmin.LoRaWAN.Application,
    AppSrv.ExAdmin.LoRaWAN.Node,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
