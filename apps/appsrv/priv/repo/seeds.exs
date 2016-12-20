# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Appsrv.Repo.insert!(%Appsrv.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Appsrv.Repo.delete_all Appsrv.User

Appsrv.User.changeset(%Appsrv.User{}, %{name: "Admin", email: "admin@appsrv.iotc.net", username: "admin", password: "secret", password_confirmation: "secret"})
|> Appsrv.Repo.insert!
