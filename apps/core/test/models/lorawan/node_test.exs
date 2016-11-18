defmodule Core.LoRaWAN.NodeTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Node

  @valid_attrs %{dev_addr: "1CF3BA77", dev_eui: "2A2B3D4E5F66778A", frames_down: 42, frames_up: 42, last_seen: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, nwk_s_key: "54C90E4A5174CBC18423213153B97A62", status: 42}
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
