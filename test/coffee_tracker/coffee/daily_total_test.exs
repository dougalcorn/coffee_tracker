defmodule CoffeeTracker.Coffee.DailyTotalTest do
  use CoffeeTracker.DataCase
  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.DailyTotal

  import CoffeeTracker.Fixtures

  setup do
    bag = insert_containers()
    {:ok, bag: bag}
  end

  describe "get_daily_total!" do
    test "has the right date", %{bag: bag} do
      date = ~D[2018-03-28]
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 450, type: "regular", container_id: bag.id})
      assert %DailyTotal{date: ^date} = DailyTotal.get_daily_total!(date)
    end
    test "adds all the measurements", %{bag: bag} do
      date = ~D[2018-03-28]
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 450, type: "regular", container_id: bag.id})
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 400, type: "regular", container_id: bag.id})
      assert %DailyTotal{unit: "g", weight: 850} = DailyTotal.get_daily_total!(date)
    end

    test "does unit conversion", %{bag: bag} do
      date = ~D[2018-03-28]
      total = 454 + 400
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "lbm", weight: 1, type: "regular", container_id: bag.id})
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 400, type: "regular", container_id: bag.id})
      assert %DailyTotal{unit: "g", weight: ^total} = DailyTotal.get_daily_total!(date)
    end

    test "subtracts out container weight" do
      date = ~D[2018-03-28]
      {:ok, hopper} = Coffee.create_container(%{name: "hopper", unit: "g", weight: 200})
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 450, type: "regular", container_id: hopper.id})
      assert %DailyTotal{weight: 250} = DailyTotal.get_daily_total!(date)
    end

    test "subtracts out the container and converts units" do
      date = ~D[2018-03-28]
      {:ok, bag} = Coffee.create_container(%{name: "bag", unit: "g", weight: 0})
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "lbm", weight: 5, type: "regular", container_id: bag.id})
      assert %DailyTotal{weight: 2270} = DailyTotal.get_daily_total!(date)
    end

    test "has the total for regular and decaf", %{bag: bag} do
      date = ~D[2018-03-28]
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 400, type: "Regular", container_id: bag.id})
      {:ok, _} = Coffee.create_measurement(%{date: date, unit: "g", weight: 400, type: "Decaf", container_id: bag.id})
      assert %DailyTotal{regular: 400, decaf: 400} = DailyTotal.get_daily_total!(date)
    end
  end
end
