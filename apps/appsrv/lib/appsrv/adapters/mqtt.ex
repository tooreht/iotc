defmodule AppSrv.Adapters.MQTT do
  @moduledoc """
  This module is an adapter for the data distribution over a MQTT broker.

  ## Transport
  The data is exchanged over [MQTT](http://mqtt.org/).
  """
  @behaviour AppSrv.Adapter

  use GenMQTT

  require Logger

  # GenMQTT behaviour

  def start_link(opts) do
    GenMQTT.start_link(__MODULE__, :ok, opts)
  end

  def on_connect(state) do
    :ok = GenMQTT.subscribe(self, "rx/app/+/node/+", 0)
    {:ok, state}
  end

  def on_publish(["rx", "app", app_eui, "node", dev_eui], message, state) do
    Logger.info "(MQTT) Receive unencrypted data on MQTT topic: #{inspect(message)} on topic rx/app/#{app_eui}/node/#{dev_eui}"
    AppSrv.LoRaWAN.Handler.send(AppSrv.LoRaWAN.Handler, message, dev_eui)
    {:ok, state}
  end

  # Adapter behaviour

  def send(bytes, node) do
    Logger.info "(MQTT) Publish decrypted data #{inspect(bytes)} on MQTT topic tx/app/#{node.application.app_eui}/node/#{node.dev_eui}"
    GenMQTT.publish(__MODULE__, "tx/app/#{node.application.app_eui}/node/#{node.dev_eui}", bytes, 0)
  end

  def register(_application, _node) do
    Logger.info "(MQTT) No registration needed for MQTT adapter"
  end
end
