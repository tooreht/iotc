defimpl ExAdmin.Authentication, for: Plug.Conn do
  alias AppSrv.Router.Helpers
  alias AppSrv.Authentication, as: Auth

  def use_authentication?(_), do: true
  def current_user(conn), do: Auth.current_user(conn)
  def current_user_name(conn), do: Auth.current_user(conn).username
  def session_path(conn, :destroy), do: Helpers.session_path(conn, :delete)
  def session_path(conn, action), do: Helpers.session_path(conn, action)
end

defmodule AppSrv.Authentication do
  def current_user(conn) do
    Coherence.current_user(conn)
  end

  def get_user_data(conn) do
    {_conn, token} = Coherence.Authentication.Token.get_token_from_header(conn, "x-auth-token")
    Coherence.CredentialStore.Agent.get_user_data(token)
  end
end
