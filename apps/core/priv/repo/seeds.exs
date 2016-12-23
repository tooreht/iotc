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

user = Core.Repo.insert! %Core.User{name: "Admin", email: "admin@example.net", username: "admin", password: "secret", password_confirmation: "secret"}
 
tresh_application = Core.Repo.insert! %Core.LoRaWAN.Application{app_eui: "70B3D57ED000177C", user_id: user.id}
allo_application = Core.Repo.insert! %Core.LoRaWAN.Application{app_eui: "70B3D57ED0000E36", user_id: user.id}
other_application = Core.Repo.insert! %Core.LoRaWAN.Application{app_eui: "AAAAAAAAD0111E11", user_id: user.id}
 
dev_addr70 = Core.Repo.insert! %Core.LoRaWAN.DeviceAddress{dev_addr: "79D2A146", last_assigned: Ecto.DateTime.utc}
dev_addr232 = Core.Repo.insert! %Core.LoRaWAN.DeviceAddress{dev_addr: "2601135F", last_assigned: Ecto.DateTime.utc}
dev_addr208 = Core.Repo.insert! %Core.LoRaWAN.DeviceAddress{dev_addr: "1D7DF6D0", last_assigned: Ecto.DateTime.utc}
dev_addr1 = Core.Repo.insert! %Core.LoRaWAN.DeviceAddress{dev_addr: "01010101", last_assigned: Ecto.DateTime.utc}
dev_addr2 = Core.Repo.insert! %Core.LoRaWAN.DeviceAddress{dev_addr: "00000002", last_assigned: Ecto.DateTime.utc}

Core.Repo.insert! %Core.LoRaWAN.Node{dev_eui: "0000000079D2A146", device_address_id: dev_addr70.id, nwk_s_key: "838401AC11E4E1DF4C6AD56A0747D2C4", application_id: allo_application.id, user_id: user.id}
Core.Repo.insert! %Core.LoRaWAN.Node{dev_eui: "00000000054AEAE8", device_address_id: dev_addr232.id, nwk_s_key: "7A395AB2BE17D4B5305FE913ACBF2AA1", application_id: tresh_application.id, user_id: user.id}
Core.Repo.insert! %Core.LoRaWAN.Node{dev_eui: "0000000011111111", device_address_id: dev_addr208.id, nwk_s_key: "CCCD5F52AAAC74788E4FDF38F5B15B79", application_id: other_application.id, user_id: user.id}
Core.Repo.insert! %Core.LoRaWAN.Node{dev_eui: "2A2B3D4E5F66778B", device_address_id: dev_addr1.id, nwk_s_key: "DF40926674B8D287C6F9BF581CF11E11", application_id: allo_application.id, user_id: user.id}
Core.Repo.insert! %Core.LoRaWAN.Node{dev_eui: "2A2B3D4E5F66778A", device_address_id: dev_addr2.id, nwk_s_key: "54C90E4A5174CBC18423213153B97A62", application_id: allo_application.id, user_id: user.id}
Core.Repo.insert! %Core.LoRaWAN.Node{dev_eui: "0101010101010101", device_address_id: dev_addr2.id, nwk_s_key: "44C01B3B2171BAC334123231BA5221DF", application_id: allo_application.id, user_id: user.id}

Core.Repo.insert! %Core.LoRaWAN.Gateway{gw_eui: "B827EBFFFE7FE413", adapter: "Semtech", user_id: user.id, latitude: 0, longitude: 1, altitude: 2}
Core.Repo.insert! %Core.LoRaWAN.Gateway{gw_eui: "B827EBFFFE8AA02D", adapter: "Semtech", user_id: user.id, latitude: 3, longitude: 4, altitude: 5}
Core.Repo.insert! %Core.LoRaWAN.Gateway{gw_eui: "B827EBFFFE8F20E2", adapter: "Semtech", user_id: user.id, latitude: 6, longitude: 7, altitude: 8}
Core.Repo.insert! %Core.LoRaWAN.Gateway{gw_eui: "B827EBFFFEFF26B2", adapter: "Semtech", user_id: user.id, latitude: nil, longitude: nil, altitude: nil}
