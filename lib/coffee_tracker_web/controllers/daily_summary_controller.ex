defmodule CoffeeTrackerWeb.DailySummaryController do
  use CoffeeTrackerWeb, :controller

  alias CoffeeTracker.Coffee

  def index(conn, _params) do
    daily_totals = Coffee.list_daily_totals()
    daily_diffs = Coffee.list_daily_diffs(daily_totals)
    render(conn, "index.html", daily_totals: daily_totals, daily_diffs: daily_diffs)
  end

  def show(conn, %{"year" => year, "month" => month, "day" => day}) do
    {:ok, date} = Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day))
    daily_total = Coffee.get_daily_total!(date)
    measurements = Coffee.list_daily_measurements(date)
    render(conn, "show.html", daily_total: daily_total, measurements: measurements)
  end
end
