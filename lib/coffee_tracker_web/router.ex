defmodule CoffeeTrackerWeb.Router do
  use CoffeeTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug CoffeeTracker.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CoffeeTrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/coffee/:year/:month/:day", DailySummaryController, :show
    get "/", DailySummaryController, :index
    get "/about", PageController, :index
  end

  # require login
  scope "/", CoffeeTrackerWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/secret", PageController, :secret

    resources "/measurements", MeasurementController
    resources "/containers", ContainerController
  end
end
