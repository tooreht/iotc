# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :core,
  ecto_repos: [Core.Repo]

# Configures the endpoint
config :core, Core.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9X4LfkIuhkhv6lSWkUef2x4CTh1/IGEaMU7P2+S3wf7tL4T9T7sTDNHvrldpvLvV",
  render_errors: [view: Core.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Core.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :core, Core.Storage.Scheduler,
  auto_start: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Core.User,
  repo: Core.Repo,
  module: Core,
  logged_out_url: "/",
  email_from_name: "tooreht",
  email_from_email: "tooreht@gmail.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable]

config :coherence, Core.Coherence.Mailer,
  adapter: Swoosh.Adapters.Local
  # api_key: "your api key here"
# %% End Coherence Configuration %%

config :ex_admin,
  repo: Core.Repo,
  module: Core,
  modules: [
    Core.ExAdmin.Dashboard,
    Core.ExAdmin.User,
    Core.ExAdmin.LoRaWAN.Gateway,
    Core.ExAdmin.LoRaWAN.Gateway.Statistics,
    Core.ExAdmin.LoRaWAN.Application,
    Core.ExAdmin.LoRaWAN.DeviceAddress,
    Core.ExAdmin.LoRaWAN.Node,
    Core.ExAdmin.LoRaWAN.Packet,
    Core.ExAdmin.LoRaWAN.GatewayPacket,
  ]
