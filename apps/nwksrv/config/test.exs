use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nwksrv, NwkSrv.Endpoint,
  http: [port: 8001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :nwksrv, NwkSrv.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "nwksrv_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :nwksrv, NwkSrv.Storage.Scheduler,
  auto_start: false
