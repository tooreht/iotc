defmodule NwkSrv.PageControllerTest do
  use NwkSrv.ConnCase

  test "GET /app", %{conn: conn} do
    conn = get conn, "/app"
    assert html_response(conn, 200) =~ "<div id=\"elm-main\"></div>"
  end
end
