defmodule AppSrv.Adapters.SIOT do
  @moduledoc """
  This module is an adapter for the data distribution to the SIOT platform.

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

  # def on_connect(state) do
  #   :ok = GenMQTT.subscribe(self, "", 0)
  #   {:ok, state}
  # end

  # def on_publish(["siot", "?", dev_eui], message, state) do
  #   Logger.info "(SIOT) Receive unencrypted data #{inspect(message)} on MQTT topic: ?"
  #   AppSrv.LoRaWAN.Handler.send(AppSrv.LoRaWAN.Handler, message, dev_eui)
  #   {:ok, state}
  # end

  # Adapter behaviour

  def send(bytes, node) do
    dst = Enum.at(bytes, 0) |> to_string
    soc = Enum.at(bytes, 1) |> to_string
    tmp = Enum.at(bytes, 2) |> to_string

    dst_topic = "siot/DAT/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-dst"
    soc_topic = "siot/DAT/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-soc"
    tmp_topic = "siot/DAT/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-tmp"

    Logger.info "(SIOT) Publish decrypted data #{dst} on MQTT topic #{dst_topic}"
    Logger.info "(SIOT) Publish decrypted data #{soc} on MQTT topic #{soc_topic}"
    Logger.info "(SIOT) Publish decrypted data #{tmp} on MQTT topic #{tmp_topic}"

    GenMQTT.publish(__MODULE__, dst_topic, dst, 0)
    GenMQTT.publish(__MODULE__, soc_topic, soc, 0)
    GenMQTT.publish(__MODULE__, tmp_topic, tmp, 0)
  end

  def register(application, node) do
    Logger.info "(SIOT) Register sensor values for node #{node.dev_eui}"
    # TODO: Let the user define the SIOT manifestation of his nodes
    dst_manifest = %{
      name: "Distance",
      type: "sensor",
      zone: %{
        name: "#{application.name}",
        guid: "#{application.app_eui}"
      },
      description: "Distance (cm)",
      valueType: "int"
    }
    soc_manifest = %{
      name: "State of charge",
      type: "sensor",
      zone: %{
        name: "#{application.name}",
        guid: "#{application.app_eui}"
      },
      description: "SOC (%)",
      valueType: "int"
    }
    tmp_manifest = %{
      name: "Temperature",
      type: "sensor",
      zone: %{
        name: "#{application.name}",
        guid: "#{application.app_eui}"
      },
      description: "Temperature (°C)",
      valueType: "int"
    }

    # Manifest each sensor value
    GenMQTT.publish(__MODULE__, "siot/MNF/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-dst", Poison.encode!(dst_manifest), 0)
    GenMQTT.publish(__MODULE__, "siot/MNF/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-soc", Poison.encode!(soc_manifest), 0)
    GenMQTT.publish(__MODULE__, "siot/MNF/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-tmp", Poison.encode!(tmp_manifest), 0)

    # Configure that the data should be stored in the database, not just in memory
    GenMQTT.publish(__MODULE__, "siot/CNF/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-dst", Poison.encode!(%{storage: "db"}), 0)
    GenMQTT.publish(__MODULE__, "siot/CNF/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-soc", Poison.encode!(%{storage: "db"}), 0)
    GenMQTT.publish(__MODULE__, "siot/CNF/#{Application.get_env(:appsrv, __MODULE__)[:licence]}/#{node.dev_eui}-tmp", Poison.encode!(%{storage: "db"}), 0)
  end
end
