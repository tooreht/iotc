defmodule Core.Router do
  use Core.Web, :router
  use Coherence.Router
  use ExAdmin.Router

  #
  # Pipelines
  #

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
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
    pipe_through :protected
    coherence_routes :protected
  end

  # App public routes
  scope "/", Core do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
    get "/app", PageController, :app
  end

  # App protected routes
  scope "/", Core do
    pipe_through :protected
  end

  # Admin
  scope "/admin", ExAdmin do
    pipe_through :protected

    admin_routes
  end

  # Other scopes may use custom stacks.
  scope "/api", Core do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/lorawan/lorawan_gateways", LoRaWAN.GatewayController, except: [:new, :edit]
    resources "/lorawan/gateway/lorawan_gateway_statistics", LoRaWAN.Gateway.StatisticsController, except: [:new, :edit]
    resources "/lorawan/lorawan_applications", LoRaWAN.ApplicationController, except: [:new, :edit]
  end
end
