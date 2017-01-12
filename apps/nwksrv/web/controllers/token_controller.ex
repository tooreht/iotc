defmodule NwkSrv.TokenController do
  @moduledoc """
  Controller responsible for API auth tokens.
  """
  use NwkSrv.Web, :controller

  import Ecto.Query

  require Coherence.Config

  alias Coherence.Authentication.Token
  alias Coherence.Config

  def create(conn, %{"email" => email, "password" => password}) do
    user_schema = Config.user_schema
    login_field = Config.login_field
    login = email

    user = Config.repo.one(from u in user_schema, where: field(u, ^login_field) == ^login)
    if user != nil and user_schema.checkpw(password, Map.get(user, Config.password_hash)) do
      token = Token.generate_token
      Token.add_credentials(token, %{uid: user.id}, Coherence.CredentialStore.Agent)
      
      send_resp(conn, :ok, token)
    else
      send_resp(conn, :forbidden, "")
    end
  end

  def delete(conn, %{"token" => token}) do
    Token.remove_credentials(token, Coherence.CredentialStore.Agent)
    send_resp(conn, :no_content, "")
  end
end
