defmodule Core.LoRaWAN.Gateway.StatisticsTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Gateway.Statistics

  @valid_attrs %{time: Ecto.DateTime.utc, ack_rate: "120.5", altitude: "120.5", latitude: "120.5", longitude: "120.5", rx_forwarded: 42, rx_total: 42, rx_valid: 42, tx_emitted: 42, tx_received: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Statistics.changeset(%Statistics{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Statistics.changeset(%Statistics{}, @invalid_attrs)
    refute changeset.valid?
  end
end
