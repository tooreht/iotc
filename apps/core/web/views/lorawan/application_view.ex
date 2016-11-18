defmodule Core.LoRaWAN.ApplicationView do
  use Core.Web, :view

  def render("index.json", %{lorawan_applications: lorawan_applications}) do
    %{data: render_many(lorawan_applications, Core.LoRaWAN.ApplicationView, "application.json")}
  end

  def render("show.json", %{application: application}) do
    %{data: render_one(application, Core.LoRaWAN.ApplicationView, "application.json")}
  end

  def render("application.json", %{application: application}) do
    %{id: application.id,
      app_eui: application.app_eui,
      name: application.name,
      user_id: application.user_id}
  end
end
