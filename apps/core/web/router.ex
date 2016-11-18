defmodule Core.Router do
  use Core.Web, :router

  #
  # Pipelines
  #

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  #
  # Scopes
  #

  # App
  scope "/", Core do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Core do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/sessions", SessionController, only: [:create]
  end
end
