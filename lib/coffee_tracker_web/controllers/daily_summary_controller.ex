defmodule CoffeeTrackerWeb.DailySummaryController do
  use CoffeeTrackerWeb, :controller

  alias CoffeeTracker.Coffee

  def index(conn, _params) do
    daily_totals = Coffee.list_daily_totals()
    daily_diffs = Coffee.list_daily_diffs(daily_totals)
    two_week_total_usage = Coffee.total_usage(daily_diffs, index_date_range(daily_diffs))
    render(conn, "index.html", daily_totals: daily_totals, daily_diffs: daily_diffs, two_week_total_usage: two_week_total_usage)
  end

  def show(conn, %{"year" => year, "month" => month, "day" => day}) do
    {:ok, date} = Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day))
    daily_total = Coffee.get_daily_total!(date)
    measurements = Coffee.list_daily_measurements(date)
    render(conn, "show.html", daily_total: daily_total, measurements: measurements)
  end

  defp index_date_range([]) do
    first = Date.utc_today
    last = Date.add(first, -14)
    Date.range(first, last)
  end

  defp index_date_range(daily_diffs) do
    first = hd(daily_diffs).date
    last = Date.add(first, -14)
    Date.range(first, last)
  end
end
