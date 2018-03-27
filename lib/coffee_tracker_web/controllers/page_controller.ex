defmodule CoffeeTrackerWeb.PageController do
  use CoffeeTrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
