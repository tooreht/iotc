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

Core.Repo.delete_all Core.LoRaWAN.Gateway
Core.Repo.delete_all Core.LoRaWAN.Node
Core.Repo.delete_all Core.LoRaWAN.DeviceAddress
Core.Repo.delete_all Core.User

%{id: user_id} = Core.User.changeset(%Core.User{}, %{username: "admin", email: "admin@example.net", password: "secret", password_confirmation: "secret"}) |> Core.Repo.insert!

Core.Storage.LoRaWAN.Node.create_node(<<70, 161, 210, 121, 0, 0, 0, 0>>, <<70, 161, 210, 121>>, <<131, 132, 1, 172, 17, 228, 225, 223, 76, 106, 213, 106, 7, 71, 210, 196>>, user_id)
Core.Storage.LoRaWAN.Node.create_node(<<232, 234, 74, 5, 0, 0, 0, 0>>, <<232, 234, 74, 5>>, <<161, 42, 191, 172, 19, 233, 95, 48, 212, 181, 23, 190, 178, 90, 57, 122>>, user_id)
Core.Storage.LoRaWAN.Node.create_node(<<139, 119, 102, 95, 78, 61, 43, 42>>, <<1, 0, 0, 0>>, <<17, 30, 241, 28, 88, 191, 249, 198, 210, 135, 184, 116, 102, 146, 64, 223>>, user_id)
Core.Storage.LoRaWAN.Node.create_node(<<138, 119, 102, 95, 78, 61, 43, 42>>, <<2, 0, 0, 0>>, <<98, 122, 185, 83, 49, 33, 35, 132, 193, 203, 116, 81, 74, 14, 201, 84>>, user_id)

Core.Storage.LoRaWAN.Gateway.create_gateway("B827EBFFFE7FE413", "semtech", user_id, 0, 1 ,2)
Core.Storage.LoRaWAN.Gateway.create_gateway("B827EBFFFE8AA02D", "semtech", user_id, 3, 4, 5)
Core.Storage.LoRaWAN.Gateway.create_gateway("B827EBFFFE8F20E2", "semtech", user_id, 6, 7, 8)
Core.Storage.LoRaWAN.Gateway.create_gateway("B827EBFFFEFF26B2", "semtech", user_id, nil, nil, nil)







