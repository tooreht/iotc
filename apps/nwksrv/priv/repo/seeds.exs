# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NwkSrv.Repo.insert!(%NwkSrv.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

NwkSrv.Repo.delete_all NwkSrv.LoRaWAN.Gateway.Statistics
NwkSrv.Repo.delete_all NwkSrv.LoRaWAN.Gateway
NwkSrv.Repo.delete_all NwkSrv.LoRaWAN.Packet
NwkSrv.Repo.delete_all NwkSrv.LoRaWAN.Node
NwkSrv.Repo.delete_all NwkSrv.LoRaWAN.DeviceAddress
NwkSrv.Repo.delete_all NwkSrv.LoRaWAN.Application
NwkSrv.Repo.delete_all NwkSrv.User

user = NwkSrv.Repo.insert! NwkSrv.User.changeset(%NwkSrv.User{}, %{name: "Admin", email: "admin@example.net", username: "admin", password: "secret"})
 
tresh_app = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Application{app_eui: "70B3D57ED000177C", user_id: user.id}
allo_app = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Application{app_eui: "70B3D57ED0000E36", user_id: user.id}
other_app = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Application{app_eui: "AAAAAAAAD0111E11", user_id: user.id}
 
dev_addr70 = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "79D2A146", last_assigned: Ecto.DateTime.utc}
dev_addr232 = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "2601135F", last_assigned: Ecto.DateTime.utc}
dev_addr208 = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "1D7DF6D0", last_assigned: Ecto.DateTime.utc}
dev_addr1 = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "01010101", last_assigned: Ecto.DateTime.utc}
dev_addr2 = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "00000002", last_assigned: Ecto.DateTime.utc}
dev_addr3 = NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.DeviceAddress{dev_addr: "26011C47", last_assigned: Ecto.DateTime.utc}

NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{dev_eui: "0000000079D2A146", device_address_id: dev_addr70.id, nwk_s_key: "838401AC11E4E1DF4C6AD56A0747D2C4", application_id: allo_app.id, user_id: user.id}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{dev_eui: "00000000054AEAE8", device_address_id: dev_addr232.id, nwk_s_key: "DCBB2BDE00339EBA7D288FF95FF419A2", application_id: tresh_app.id, user_id: user.id}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{dev_eui: "0000000011111111", device_address_id: dev_addr208.id, nwk_s_key: "CCCD5F52AAAC74788E4FDF38F5B15B79", application_id: other_app.id, user_id: user.id}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{dev_eui: "2A2B3D4E5F66778B", device_address_id: dev_addr1.id, nwk_s_key: "E3A71DA6B2F1D2F7422ACE702FF56E74", application_id: allo_app.id, user_id: user.id}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{dev_eui: "2A2B3D4E5F66778A", device_address_id: dev_addr2.id, nwk_s_key: "0D49F5CED7097CD16CBD67FD3E2BCF5D", application_id: allo_app.id, user_id: user.id}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{dev_eui: "0101010101010101", device_address_id: dev_addr2.id, nwk_s_key: "44C01B3B2171BAC334123231BA5221DF", application_id: allo_app.id, user_id: user.id}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Node{dev_eui: "0025EB4E5983C7BF", device_address_id: dev_addr3.id, nwk_s_key: "01B9A4BEE9FBAE7C14CD3BBDFD4580E0", application_id: tresh_app.id, user_id: user.id}

NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Gateway{gw_eui: "B827EBFFFE7FE413", adapter: "Semtech", user_id: user.id, latitude: 0, longitude: 1, altitude: 2}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Gateway{gw_eui: "B827EBFFFE8AA02D", adapter: "Semtech", user_id: user.id, latitude: 3, longitude: 4, altitude: 5}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Gateway{gw_eui: "B827EBFFFE8F20E2", adapter: "Semtech", user_id: user.id, latitude: 6, longitude: 7, altitude: 8}
NwkSrv.Repo.insert! %NwkSrv.LoRaWAN.Gateway{gw_eui: "B827EBFFFEFF26B2", adapter: "Semtech", user_id: user.id, latitude: nil, longitude: nil, altitude: nil}
