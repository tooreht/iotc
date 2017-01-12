# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nwksrv,
  ecto_repos: [NwkSrv.Repo]

# Configures the endpoint
config :nwksrv, NwkSrv.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9X4LfkIuhkhv6lSWkUef2x4CTh1/IGEaMU7P2+S3wf7tL4T9T7sTDNHvrldpvLvV",
  render_errors: [view: NwkSrv.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NwkSrv.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :nwksrv, NwkSrv.Storage.Scheduler,
  auto_start: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :xain, :after_callback, {Phoenix.HTML, :raw}

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: NwkSrv.User,
  repo: NwkSrv.Repo,
  module: NwkSrv,
  logged_out_url: "/",
  email_from_name: "tooreht",
  email_from_email: "tooreht@gmail.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable]

config :coherence, NwkSrv.Coherence.Mailer,
  adapter: Swoosh.Adapters.Local
  # api_key: "your api key here"
# %% End Coherence Configuration %%

config :ex_admin,
  repo: NwkSrv.Repo,
  module: NwkSrv,
  modules: [
    NwkSrv.ExAdmin.Dashboard,
    NwkSrv.ExAdmin.User,
    NwkSrv.ExAdmin.LoRaWAN.Gateway,
    NwkSrv.ExAdmin.LoRaWAN.Gateway.Statistics,
    NwkSrv.ExAdmin.LoRaWAN.Application,
    NwkSrv.ExAdmin.LoRaWAN.DeviceAddress,
    NwkSrv.ExAdmin.LoRaWAN.Node,
    NwkSrv.ExAdmin.LoRaWAN.Packet,
    NwkSrv.ExAdmin.LoRaWAN.GatewayPacket,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
