defmodule Core.LoRaWAN.DeviceAddressController do
  use Core.Web, :controller

  alias Core.LoRaWAN.DeviceAddress

  def index(conn, _params) do
    lorawan_device_addresses = Repo.all(DeviceAddress)
    render(conn, "index.json", lorawan_device_addresses: lorawan_device_addresses)
  end

  def create(conn, %{"device_address" => device_address_params}) do
    changeset = DeviceAddress.changeset(%DeviceAddress{}, device_address_params)

    case Repo.insert(changeset) do
      {:ok, device_address} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", device_address_path(conn, :show, device_address))
        |> render("show.json", device_address: device_address)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    device_address = Repo.get!(DeviceAddress, id)
    render(conn, "show.json", device_address: device_address)
  end

  def update(conn, %{"id" => id, "device_address" => device_address_params}) do
    device_address = Repo.get!(DeviceAddress, id)
    changeset = DeviceAddress.changeset(device_address, device_address_params)

    case Repo.update(changeset) do
      {:ok, device_address} ->
        render(conn, "show.json", device_address: device_address)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device_address = Repo.get!(DeviceAddress, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(device_address)

    send_resp(conn, :no_content, "")
  end
end
