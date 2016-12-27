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

node = Appsrv.Repo.insert! %Appsrv.LoRaWAN.Node{name: "SuperNode", dev_eui: "2A2B3D4E5F66778A", dev_addr: "1CF3BA77", app_key: "9056E66E691EC92131DC6A16DB533C81", app_s_key: "8997C1DDA114D001B15E6CB58DB538A6", nwk_s_key: "54C90E4A5174CBC18423213153B97A62", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: app.id, user_id: user.id}
