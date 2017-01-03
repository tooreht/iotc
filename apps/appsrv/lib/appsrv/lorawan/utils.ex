defmodule Appsrv.LoRaWAN.Utils do

  alias Appsrv.LoRaWAN.Node
  
  import Ecto.Query

  def get_node(dev_eui) do
    from(n in Node,
      select: n,
      where: n.dev_eui == ^dev_eui)
    |> Appsrv.Repo.one
    |> Appsrv.Repo.preload([:application])
  end

  def get_key(node, f_port) do
    if f_port == 0 do
      node.nwk_s_key
    else
      node.app_s_key
    end
    |> Base.decode16!
  end
end
