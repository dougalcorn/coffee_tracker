defmodule CoffeeTrackerWeb.DailySummaryControllerTest do
  use CoffeeTrackerWeb.ConnCase

  alias CoffeeTracker.Coffee

  describe "index" do
    test "shows a total for each day", %{conn: conn} do
      {:ok, _} = Coffee.create_measurement(%{date: ~D[2018-03-27], unit: "g", weight: 450, type: "regular"})
      {:ok, _} = Coffee.create_measurement(%{date: ~D[2018-03-28], unit: "g", weight: 450, type: "regular"})
      response = get conn, daily_summary_path(conn, :index)
      assert html_response(response, 200)
    end
  end

  describe "show" do
    test "renders the daily total for that day", %{conn: conn} do
      {:ok, _} = Coffee.create_measurement(%{date: ~D[2018-03-28], unit: "g", weight: 450, type: "regular"})
      url = daily_summary_path(conn, :show, "2018", "3", "28")
      response = get conn, url
      assert html_response(response, 200)
    end
  end
end
