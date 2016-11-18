defmodule Core.LoRaWAN.PacketTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Packet

  @valid_attrs %{channel: 42, code_rate: "4/5", data_rate: "SF7BW125", frequency: "120.5", modulation: "LORA", number: 42, size: 42, type: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Packet.changeset(%Packet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Packet.changeset(%Packet{}, @invalid_attrs)
    refute changeset.valid?
  end
end
