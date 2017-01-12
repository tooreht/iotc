defmodule NwkSrv.LoRaWAN.GatewayPacketController do
  use NwkSrv.Web, :controller

  alias NwkSrv.LoRaWAN.GatewayPacket

  def index(conn, _params) do
    gateways_packets = Repo.all(GatewayPacket)
    render(conn, "index.json", gateways_packets: gateways_packets)
  end

  def create(conn, %{"gateway_packet" => gateway_packet_params}) do
    changeset = GatewayPacket.changeset(%GatewayPacket{}, gateway_packet_params)

    case Repo.insert(changeset) do
      {:ok, gateway_packet} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", gateway_packet_path(conn, :show, gateway_packet))
        |> render("show.json", gateway_packet: gateway_packet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(NwkSrv.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gateway_packet = Repo.get!(GatewayPacket, id)
    render(conn, "show.json", gateway_packet: gateway_packet)
  end

  def update(conn, %{"id" => id, "gateway_packet" => gateway_packet_params}) do
    gateway_packet = Repo.get!(GatewayPacket, id)
    changeset = GatewayPacket.changeset(gateway_packet, gateway_packet_params)

    case Repo.update(changeset) do
      {:ok, gateway_packet} ->
        render(conn, "show.json", gateway_packet: gateway_packet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(NwkSrv.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gateway_packet = Repo.get!(GatewayPacket, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(gateway_packet)

    send_resp(conn, :no_content, "")
  end
end
