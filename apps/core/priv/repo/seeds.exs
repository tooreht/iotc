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
Core.Repo.delete_all Core.LoRaWAN.Packet
Core.Repo.delete_all Core.LoRaWAN.Node
Core.Repo.delete_all Core.LoRaWAN.DeviceAddress
Core.Repo.delete_all Core.LoRaWAN.Application
Core.Repo.delete_all Core.User

%{id: user_id} = 
Core.User.changeset(%Core.User{}, %{name: "Admin", email: "admin@example.net", username: "admin", password: "secret", password_confirmation: "secret"})
|> Core.Repo.insert!

%{id: tresh_application_id} = Core.Storage.LoRaWAN.Application.create(%{rev_app_eui: <<124, 23, 0, 208, 126, 213, 179, 112>>, user_id: user_id})
%{id: allo_application_id} = Core.Storage.LoRaWAN.Application.create(%{rev_app_eui: <<54, 14, 0, 208, 126, 213, 179, 112>>, user_id: user_id})

%{id: dev_addr70} = Core.Storage.LoRaWAN.DeviceAddress.create(%{rev_dev_addr: <<70, 161, 210, 121>>})
%{id: dev_addr232} = Core.Storage.LoRaWAN.DeviceAddress.create(%{rev_dev_addr: <<232, 234, 74, 5>>})
%{id: dev_addr1} = Core.Storage.LoRaWAN.DeviceAddress.create(%{rev_dev_addr: <<1, 0, 0, 0>>})
%{id: dev_addr2} = Core.Storage.LoRaWAN.DeviceAddress.create(%{rev_dev_addr: <<2, 0, 0, 0>>})

Core.Storage.LoRaWAN.Node.create(%{rev_dev_eui: <<70, 161, 210, 121, 0, 0, 0, 0>>, device_address_id: dev_addr70, rev_nwk_s_key: <<131, 132, 1, 172, 17, 228, 225, 223, 76, 106, 213, 106, 7, 71, 210, 196>>, application_id: allo_application_id, user_id: user_id})
Core.Storage.LoRaWAN.Node.create(%{rev_dev_eui: <<232, 234, 74, 5, 0, 0, 0, 0>>, device_address_id: dev_addr232, rev_nwk_s_key: <<161, 42, 191, 172, 19, 233, 95, 48, 212, 181, 23, 190, 178, 90, 57, 122>>, application_id: tresh_application_id, user_id: user_id})
Core.Storage.LoRaWAN.Node.create(%{rev_dev_eui: <<139, 119, 102, 95, 78, 61, 43, 42>>, device_address_id: dev_addr1, rev_nwk_s_key: <<17, 30, 241, 28, 88, 191, 249, 198, 210, 135, 184, 116, 102, 146, 64, 223>>, application_id: allo_application_id, user_id: user_id})
Core.Storage.LoRaWAN.Node.create(%{rev_dev_eui: <<138, 119, 102, 95, 78, 61, 43, 42>>, device_address_id: dev_addr2, rev_nwk_s_key: <<98, 122, 185, 83, 49, 33, 35, 132, 193, 203, 116, 81, 74, 14, 201, 84>>, application_id: allo_application_id, user_id: user_id})

Core.Storage.LoRaWAN.Gateway.create(%{gw_eui: "B827EBFFFE7FE413", adapter: "Semtech", user_id: user_id, latitude: 0, longitude: 1, altitude: 2})
Core.Storage.LoRaWAN.Gateway.create(%{gw_eui: "B827EBFFFE8AA02D", adapter: "Semtech", user_id: user_id, latitude: 3, longitude: 4, altitude: 5})
Core.Storage.LoRaWAN.Gateway.create(%{gw_eui: "B827EBFFFE8F20E2", adapter: "Semtech", user_id: user_id, latitude: 6, longitude: 7, altitude: 8})
Core.Storage.LoRaWAN.Gateway.create(%{gw_eui: "B827EBFFFEFF26B2", adapter: "Semtech", user_id: user_id, latitude: nil, longitude: nil, altitude: nil})
