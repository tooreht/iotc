defmodule NwkSrv.Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:core)

    path = Application.app_dir(:core, "priv/repo/migrations")

    Ecto.Migrator.run(NwkSrv.Repo, path, :up, all: true)
  end
end
