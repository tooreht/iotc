defmodule Core.PageControllerTest do
  use Core.ConnCase

  test "GET /app", %{conn: conn} do
    conn = get conn, "/app"
    assert html_response(conn, 200) =~ "<div id=\"elm-main\"></div>"
  end
end
