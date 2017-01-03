defmodule Appsrv.Adapters.SIOT do
  @moduledoc """
  This module is an adapter for the data distribution to the SIOT platform.

  ## Transport
  The data is exchanged over [MQTT](http://mqtt.org/).
  """
  use GenMQTT

  require Logger

  # GenMQTT behaviour

  def start_link(opts) do
    GenMQTT.start_link(__MODULE__, :ok, opts)
  end

  def on_connect(state) do
    # TODO: Add subscription through SIOT manifest
    :ok = GenMQTT.subscribe(self, "rx/app/+/node/+", 0)
    {:ok, state}
  end

  def on_publish(["rx", "app", app_eui, "node", dev_eui], message, state) do
    # TODO: Adapt to SIOT specific topics
    Logger.info "(SIOT) Receive unencrypted data on MQTT topic: #{inspect(message)} on topic rx/app/#{app_eui}/node/#{dev_eui}"
    Appsrv.LoRaWAN.Handler.send(Appsrv.LoRaWAN.Handler, message, dev_eui)
    {:ok, state}
  end

  # Adapter behaviour

  def send(bytes, node) do
    # TODO: Adapt to SIOT specific topics
    Logger.info "(SIOT) Publish decrypted data #{inspect(bytes)} on MQTT topic tx/app/#{node.application.app_eui}/node/#{node.dev_eui}"
    GenMQTT.publish(__MODULE__, "tx/app/#{node.application.app_eui}/node/#{node.dev_eui}", bytes, 0)
  end
end
