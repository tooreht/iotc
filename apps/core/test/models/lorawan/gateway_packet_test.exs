defmodule Core.LoRaWAN.GatewayPacketTest do
  use Core.ModelCase

  alias Core.LoRaWAN.GatewayPacket

  @valid_attrs %{
    crc_status: 42,
    rf_chain: 42,
    rssi: 42,
    snr: 42,
    time: 42,
    gateway_id: 42,
    packet_id: 42
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GatewayPacket.changeset(%GatewayPacket{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GatewayPacket.changeset(%GatewayPacket{}, @invalid_attrs)
    refute changeset.valid?
  end
end
