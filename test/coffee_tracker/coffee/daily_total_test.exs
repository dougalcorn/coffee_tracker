defmodule CoffeeTracker.Coffee.DailyTotalTest do
  use CoffeeTracker.DataCase
  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.DailyTotal

  import CoffeeTracker.Fixtures

  setup do
    insert_containers()
    :ok
  end

  describe "get_daily_total!" do
    test "adds all the measurements with the same units" do
      date = ~D[2018-03-28]
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 450, type: "regular"})
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 400, type: "regular"})
      assert %DailyTotal{unit: "g", weight: 850} = DailyTotal.get_daily_total!(date)
    end

    test "does unit conversion" do
      date = ~D[2018-03-28]
      total = 2268 + 400
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "lbm", weight: 1, type: "regular"})
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 400, type: "regular"})
      assert %DailyTotal{unit: "g", weight: ^total} = DailyTotal.get_daily_total!(date)
    end
  end
end
