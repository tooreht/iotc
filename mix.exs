defmodule Iotc.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     # Docs
     name: "IoTc",
     source_url: "https://github.com/tooreht/iotc",
     homepage_url: "http://iotc.tooreht.net",
     docs: [source_ref: "HEAD",
            main: "main", # The main page in the docs
            logo: "docs/assets/logo.png",
            assets: "docs/assets",
            extras: ["docs/main.md", "README.md"]],
     deps: deps(),
     aliases: aliases()]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev},
      {:distillery, "~> 1.0.0"}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
     "ecto.seed": ["run apps/appsrv/priv/repo/seeds.exs", "run apps/nwksrv/priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
