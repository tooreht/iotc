defmodule NwkSrv.PageController do
  use NwkSrv.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def app(conn, _params) do
    render conn, "app_index.html"
  end
end
