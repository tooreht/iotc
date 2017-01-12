defmodule AppSrv.LoRaWAN.NodeTest do
  use AppSrv.ModelCase

  alias AppSrv.LoRaWAN.Node

  @valid_attrs %{
      name: "AlloAllo",
      dev_eui: "2A2B3D4E5F66778A",
      dev_addr: "1CF3BA77",
      app_key: "9056E66E691EC92131DC6A16DB533C81",
      app_s_key: "8997C1DDA114D001B15E6CB58DB538A6",
      nwk_s_key: "54C90E4A5174CBC18423213153B97A62",
      relax_fcnt: true,
      rx1_dr_offset: 42,
      rx2_dr: 42,
      rx_delay: 42,
      rx_window: 42,
      application_id: 1,
      user_id: 1
    }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Node.changeset(%Node{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Node.changeset(%Node{}, @invalid_attrs)
    refute changeset.valid?
  end
end
