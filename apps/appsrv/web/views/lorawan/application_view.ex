defmodule AppSrv.LoRaWAN.ApplicationView do
  use AppSrv.Web, :view

  def render("index.json", %{lorawan_applications: lorawan_applications}) do
    %{data: render_many(lorawan_applications, AppSrv.LoRaWAN.ApplicationView, "application.json")}
  end

  def render("show.json", %{application: application}) do
    %{data: render_one(application, AppSrv.LoRaWAN.ApplicationView, "application.json")}
  end

  def render("application.json", %{application: application}) do
    %{id: application.id,
      name: application.name,
      app_eui: application.app_eui,
      app_root_key: application.app_root_key}
  end
end
