defmodule AppSrv.Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:appsrv)

    path = Application.app_dir(:appsrv, "priv/repo/migrations")

    Ecto.Migrator.run(AppSrv.Repo, path, :up, all: true)
  end
end
