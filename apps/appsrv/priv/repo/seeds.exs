# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AppSrv.Repo.insert!(%AppSrv.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

AppSrv.Repo.delete_all AppSrv.LoRaWAN.Node
AppSrv.Repo.delete_all AppSrv.LoRaWAN.Application
AppSrv.Repo.delete_all AppSrv.User

user = AppSrv.Repo.insert! AppSrv.User.changeset(%AppSrv.User{}, %{name: "Admin", email: "admin@example.net", username: "admin", password: "secret"})

tresh_app = AppSrv.Repo.insert! %AppSrv.LoRaWAN.Application{app_eui: "70B3D57ED000177C", app_root_key: "A1B2C3D4E5F60000", name: "Tresh", user_id: user.id}
allo_app = AppSrv.Repo.insert! %AppSrv.LoRaWAN.Application{app_eui: "70B3D57ED0000E36", app_root_key: "A1B2C3D4E5F60001", name: "AlloAllo", user_id: user.id}
other_app = AppSrv.Repo.insert! %AppSrv.LoRaWAN.Application{app_eui: "AAAAAAAAD0111E11", app_root_key: "A1B2C3D4E5F60002", name: "Other", user_id: user.id}

AppSrv.Repo.insert! %AppSrv.LoRaWAN.Node{name: "0000000079D2A146", dev_eui: "0000000079D2A146", dev_addr: "79D2A146", app_key: "00000000000000000000000000000000", app_s_key: "D4A10CC6C632A264025FC3414E709F47", nwk_s_key: "838401AC11E4E1DF4C6AD56A0747D2C4", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: allo_app.id, user_id: user.id}
AppSrv.Repo.insert! %AppSrv.LoRaWAN.Node{name: "00000000054aeae8", dev_eui: "00000000054AEAE8", dev_addr: "2601135F", app_key: "00000000000000000000000000000000", app_s_key: "F29AE50B8B907243EC3055A9D75479B8", nwk_s_key: "DCBB2BDE00339EBA7D288FF95FF419A2", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: tresh_app.id, user_id: user.id}
AppSrv.Repo.insert! %AppSrv.LoRaWAN.Node{name: "SuperNode1", dev_eui: "0000000011111111", dev_addr: "1D7DF6D0", app_key: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", app_s_key: "8997C1DDA114D001B15E6CB58DB538A6", nwk_s_key: "CCCD5F52AAAC74788E4FDF38F5B15B79", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: other_app.id, user_id: user.id}
AppSrv.Repo.insert! %AppSrv.LoRaWAN.Node{name: "2A2B3D4E5F66778B", dev_eui: "2A2B3D4E5F66778B", dev_addr: "01010101", app_key: "BFB9DBE54E8BD183183B70A86A67AF49", app_s_key: "27D96E07661EA37AA4FCEC6BD99B112A", nwk_s_key: "E3A71DA6B2F1D2F7422ACE702FF56E74", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: allo_app.id, user_id: user.id}
AppSrv.Repo.insert! %AppSrv.LoRaWAN.Node{name: "2A2B3D4E5F66778A", dev_eui: "2A2B3D4E5F66778A", dev_addr: "00000002", app_key: "9056E66E691EC92131DC6A16DB533C81", app_s_key: "86F09F4A256B75C42384B5724F210D00", nwk_s_key: "0D49F5CED7097CD16CBD67FD3E2BCF5D", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: allo_app.id, user_id: user.id}
AppSrv.Repo.insert! %AppSrv.LoRaWAN.Node{name: "SuperNode2", dev_eui: "0101010101010101", dev_addr: "00000002", app_key: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", app_s_key: "8997C1DDA114D001B15E6CB58DB538A6", nwk_s_key: "44C01B3B2171BAC334123231BA5221DF", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: allo_app.id, user_id: user.id}
AppSrv.Repo.insert! %AppSrv.LoRaWAN.Node{name: "marcs_abp", dev_eui: "0025EB4E5983C7BF", dev_addr: "26011C47", app_key: "00000000000000000000000000000000", app_s_key: "3C93396D451E83073F294EB246F08CD7", nwk_s_key: "01B9A4BEE9FBAE7C14CD3BBDFD4580E0", relax_fcnt: true, rx1_dr_offset: 42, rx2_dr: 42, rx_delay: 42, rx_window: 42, application_id: tresh_app.id, user_id: user.id}
