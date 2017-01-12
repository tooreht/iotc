defmodule NwkSrv.LoRaWAN.ApplicationView do
  use NwkSrv.Web, :view

  def render("index.json", %{lorawan_applications: lorawan_applications}) do
    %{data: render_many(lorawan_applications, NwkSrv.LoRaWAN.ApplicationView, "application.json")}
  end

  def render("show.json", %{application: application}) do
    %{data: render_one(application, NwkSrv.LoRaWAN.ApplicationView, "application.json")}
  end

  def render("application.json", %{application: application}) do
    %{id: application.id,
      app_eui: application.app_eui,
      user_id: application.user_id}
  end
end
