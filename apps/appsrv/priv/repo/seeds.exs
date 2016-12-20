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

Appsrv.Repo.delete_all Appsrv.LoRaWAN.Application
Appsrv.Repo.delete_all Appsrv.User

user = Appsrv.Repo.insert! Appsrv.User.changeset(%Appsrv.User{}, %{name: "Admin", email: "admin@example.net", username: "admin", password: "secret"})

app = Appsrv.Repo.insert! %Appsrv.LoRaWAN.Application{app_eui: "70B3D57ED0000E36", app_root_key: "A1B2C3D4E5F60000", name: "AlloAllo", user_id: user.id}
