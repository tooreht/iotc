defimpl ExAdmin.Authentication, for: Plug.Conn do
  alias Appsrv.Router.Helpers
  alias Appsrv.Authentication, as: Auth

  def use_authentication?(_), do: true
  def current_user(conn), do: Auth.current_user(conn)
  def current_user_name(conn), do: Auth.current_user(conn).username
  def session_path(conn, :destroy), do: Helpers.session_path(conn, :delete)
  def session_path(conn, action), do: Helpers.session_path(conn, action)
end

defmodule Appsrv.Authentication do
  def current_user(conn) do
    Coherence.current_user(conn)
  end
end
