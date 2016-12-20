defmodule Appsrv.Router do
  use Appsrv.Web, :router
  use Coherence.Router
  use ExAdmin.Router

  #
  # Pipelines
  #

  # Browser

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :session do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, login: true
  end

  # API

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :token do
    plug :accepts, ["json"]
    # plug Coherence.Authentication.Token, source: :params, param: "auth_token"
    plug Coherence.Authentication.Token,
      source: :header,
      param: "x-auth-token", # Must be lower case, convention in plug
      error: ~s'{"error":"authentication required"}'
  end

  #
  # Scopes
  #

  # Coherence
  scope "/" do
    pipe_through :browser
    coherence_routes
  end

  scope "/" do
    pipe_through :session
    coherence_routes :protected
  end

  scope "/", Appsrv do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Session Auth routes
  scope "/", Appsrv do
    pipe_through :session
  end

  scope "/admin", ExAdmin do
    pipe_through :session

    admin_routes
  end

  # API
  scope "/api", Appsrv do
    pipe_through :api

    post    "/auth/token", TokenController, :create
    delete  "/auth/token/:token", TokenController, :delete
  end

  # API Token
  scope "/api", Appsrv do
    pipe_through :token

    resources "/lorawan/applications", LoRaWAN.ApplicationController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end
end
