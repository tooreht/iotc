defmodule Appsrv.Adapter do
  @moduledoc """
  Defines the behaviour for adapters.
  """
  alias Appsrv.LoRaWAN.Application
  alias Appsrv.LoRaWAN.Node

  @doc "Action when node data is sent over the adapter."
  @callback send(bytes :: charlist, node :: %Node{}) :: any
  @doc "Action when node is added or updated."
  @callback register(application :: %Application{}, node :: %Node{}) :: any
end
