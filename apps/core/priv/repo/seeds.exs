# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Core.Repo.insert!(%Core.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Core.Repo.delete_all Core.User

Core.User.changeset(%Core.User{}, %{username: "admin", email: "admin@example.net", password: "secret", password_confirmation: "secret"})
|> Core.Repo.insert!
