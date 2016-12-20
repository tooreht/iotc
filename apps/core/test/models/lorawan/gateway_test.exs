defmodule Core.LoRaWAN.GatewayTest do
  use Core.ModelCase

  alias Core.LoRaWAN.Gateway

  @valid_attrs %{adapter: "some content", altitude: "120.5", gw_eui: "B827EBFFFE7B80CD", ip: "some content", last_seen: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, latitude: "120.5", longitude: "120.5", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Gateway.changeset(%Gateway{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Gateway.changeset(%Gateway{}, @invalid_attrs)
    refute changeset.valid?
  end
end
