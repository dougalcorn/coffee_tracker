defmodule CoffeeTrackerWeb.Router do
  use CoffeeTrackerWeb, :router

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

  scope "/", CoffeeTrackerWeb do
    pipe_through :browser # Use the default browser stack

    resources "/measurements", MeasurementController
    resources "/containers", ContainerController
    get "/coffee/:year/:month/:day", DailySummaryController, :show
    get "/", DailySummaryController, :index
    get "/about", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CoffeeTrackerWeb do
  #   pipe_through :api
  # end
end
