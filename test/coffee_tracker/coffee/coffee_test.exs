defmodule CoffeeTracker.CoffeeTest do
  use CoffeeTracker.DataCase

  alias CoffeeTracker.Coffee

  describe "containers" do
    alias CoffeeTracker.Coffee.Container

    @valid_attrs %{name: "some name", unit: "some unit", weight: 42}
    @update_attrs %{name: "some updated name", unit: "some updated unit", weight: 43}
    @invalid_attrs %{name: nil, unit: nil, weight: nil}

    def container_fixture(attrs \\ %{}) do
      {:ok, container} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Coffee.create_container()

      container
    end

    test "list_containers/0 returns all containers" do
      container = container_fixture()
      assert Coffee.list_containers() == [container]
    end

    test "get_container!/1 returns the container with given id" do
      container = container_fixture()
      assert Coffee.get_container!(container.id) == container
    end

    test "create_container/1 with valid data creates a container" do
      assert {:ok, %Container{} = container} = Coffee.create_container(@valid_attrs)
      assert container.name == "some name"
      assert container.unit == "some unit"
      assert container.weight == 42
    end

    test "create_container/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Coffee.create_container(@invalid_attrs)
    end

    test "update_container/2 with valid data updates the container" do
      container = container_fixture()
      assert {:ok, container} = Coffee.update_container(container, @update_attrs)
      assert %Container{} = container
      assert container.name == "some updated name"
      assert container.unit == "some updated unit"
      assert container.weight == 43
    end

    test "update_container/2 with invalid data returns error changeset" do
      container = container_fixture()
      assert {:error, %Ecto.Changeset{}} = Coffee.update_container(container, @invalid_attrs)
      assert container == Coffee.get_container!(container.id)
    end

    test "delete_container/1 deletes the container" do
      container = container_fixture()
      assert {:ok, %Container{}} = Coffee.delete_container(container)
      assert_raise Ecto.NoResultsError, fn -> Coffee.get_container!(container.id) end
    end

    test "change_container/1 returns a container changeset" do
      container = container_fixture()
      assert %Ecto.Changeset{} = Coffee.change_container(container)
    end
  end

  describe "measurements" do
    alias CoffeeTracker.Coffee.Measurement

    @valid_attrs %{date: ~D[2010-04-17], type: "some type", unit: "some unit", weight: 42, delivery: false}
    @update_attrs %{date: ~D[2011-05-18], type: "some updated type", unit: "some updated unit", weight: 43}
    @invalid_attrs %{date: nil, type: nil, unit: nil, weight: nil}

    def measurement_fixture(attrs \\ %{}) do
      {:ok, measurement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Coffee.create_measurement()

      measurement
    end

    test "list_measurements/0 returns all measurements" do
      measurement = measurement_fixture()
      assert Coffee.list_measurements() == [measurement]
    end

    test "get_measurement!/1 returns the measurement with given id" do
      measurement = measurement_fixture()
      assert Coffee.get_measurement!(measurement.id) == measurement
    end

    test "create_measurement/1 with a container_id creates the reference" do
      {:ok, container} = Coffee.create_container(%{name: "bag", weight: 450, unit: "g"})
      measurement = measurement_fixture(%{container_id: container.id}) |> Repo.preload(:container)
      assert measurement.container_id == container.id
      assert measurement.container == container
    end

    test "create_measurement/1 with valid data creates a measurement" do
      assert {:ok, %Measurement{} = measurement} = Coffee.create_measurement(@valid_attrs)
      assert measurement.date == ~D[2010-04-17]
      assert measurement.type == "some type"
      assert measurement.unit == "some unit"
      assert measurement.weight == 42
    end

    test "create_measurement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Coffee.create_measurement(@invalid_attrs)
    end

    test "update_measurement/2 with valid data updates the measurement" do
      measurement = measurement_fixture()
      assert {:ok, measurement} = Coffee.update_measurement(measurement, @update_attrs)
      assert %Measurement{} = measurement
      assert measurement.date == ~D[2011-05-18]
      assert measurement.type == "some updated type"
      assert measurement.unit == "some updated unit"
      assert measurement.weight == 43
    end

    test "update_measurement/2 with invalid data returns error changeset" do
      measurement = measurement_fixture()
      assert {:error, %Ecto.Changeset{}} = Coffee.update_measurement(measurement, @invalid_attrs)
      assert measurement == Coffee.get_measurement!(measurement.id)
    end

    test "delete_measurement/1 deletes the measurement" do
      measurement = measurement_fixture()
      assert {:ok, %Measurement{}} = Coffee.delete_measurement(measurement)
      assert_raise Ecto.NoResultsError, fn -> Coffee.get_measurement!(measurement.id) end
    end

    test "change_measurement/1 returns a measurement changeset" do
      measurement = measurement_fixture()
      assert %Ecto.Changeset{} = Coffee.change_measurement(measurement)
    end
  end

  describe "list_daily_totals" do
    alias CoffeeTracker.Coffee.DailyTotal

    test "returns a single total for every day there's a measurement" do
      {:ok, container} = Coffee.create_container(%{unit: "g", weight: 0, name: "bag"})
      today = Date.utc_today()
      {:ok, _} = Coffee.create_measurement(%{date: today, unit: "g", weight: 450, type: "regular", container_id: container.id})
      {:ok, _} = Coffee.create_measurement(%{date: today, unit: "g", weight: 450, type: "regular", container_id: container.id})
      {:ok, _} = Coffee.create_measurement(%{date: Date.add(today, 1), unit: "g", weight: 450, type: "regular", container_id: container.id})
      assert [%DailyTotal{}, %DailyTotal{}] = Coffee.list_daily_totals()
    end
  end

  describe "list_daily_measurements" do
    alias CoffeeTracker.Coffee.Measurement

    test "returns all the individual measurements for the day" do
      {:ok, container} = Coffee.create_container(%{unit: "g", weight: 0, name: "bag"})
      {:ok, _} = Coffee.create_measurement(%{date: ~D[2018-03-27], unit: "g", weight: 450, type: "regular", container_id: container.id})
      {:ok, _} = Coffee.create_measurement(%{date: ~D[2018-03-27], unit: "g", weight: 450, type: "regular", container_id: container.id})
      {:ok, _} = Coffee.create_measurement(%{date: ~D[2018-03-28], unit: "g", weight: 450, type: "regular", container_id: container.id})
      assert [%Measurement{date: ~D[2018-03-27]}, %Measurement{date: ~D[2018-03-27]}] = Coffee.list_daily_measurements(~D[2018-03-27])
    end
  end

  describe "list_daily_diffs" do
    alias CoffeeTracker.Coffee.DailyTotal

    test "returns a list of daily total structs with the weight differences" do
      three = %DailyTotal{date: ~D[2018-03-29], weight: (400 + 908), unit: "g"}
      two = %DailyTotal{date: ~D[2018-03-28], weight: (430 + 908), unit: "g"}
      one = %DailyTotal{date: ~D[2018-03-27], weight: 450, unit: "g"}
      daily_totals = [three, two, one]
      delivery_totals = [
        %DailyTotal{date: ~D[2018-03-29], weight: 0, unit: "g"}, # no delivery this day
        %DailyTotal{date: ~D[2018-03-28], weight: 908, unit: "g"}, # 2 pound delivery
        %DailyTotal{date: ~D[2018-03-27], weight: 0, unit: "g"}, # no delivery this day
      ]
      assert [
        %DailyTotal{weight: -30}, # 400 - 430
        %DailyTotal{weight: -20}, # 430 - 1358
        %DailyTotal{weight: 0}  # this is the first day, so there's no diff for previous day 
      ] = Coffee.list_daily_diffs(daily_totals, delivery_totals)
    end
  end

  describe "get_daily_diff!" do
    alias CoffeeTracker.Coffee.DailyTotal

    test "with only a total" do
      today = %DailyTotal{date: ~D[2018-03-28], weight: 3230, regular: 1230, decaf: 2000, unit: "g"}
      prev = %DailyTotal{date: ~D[2018-03-27], weight: 3430, regular: 1330, decaf: 2100, unit: "g"}
      assert %DailyTotal{date: ~D[2018-03-28], weight: -200, regular: -100, decaf: -100, unit: "g"} = Coffee.get_daily_diff!(today, prev)
    end

    test "with a delivery" do
      delivery = %DailyTotal{unit: "g", weight: 908, regular: 454, decaf: 454} # 2 pounds delivered, 1 pound each of reg and decaf
      yesterday = %DailyTotal{date: ~D[2018-03-27], weight: (454+454), regular: 454, decaf: 454, unit: "g"} #  2 pounds, 1 of each
      usage = %DailyTotal{weight: -200, regular: -100, decaf: -100, date: ~D[2018-03-28], unit: "g"}
      weight = yesterday.weight + delivery.weight + usage.weight
      regular = yesterday.regular + delivery.regular + usage.regular
      decaf = yesterday.decaf + delivery.decaf + usage.decaf
      today = %DailyTotal{date: ~D[2018-03-28], weight: weight, regular: regular, decaf: decaf, unit: "g"}

      assert usage == Coffee.get_daily_diff!(today, yesterday, delivery)
    end
  end

  describe "total_usage" do
    alias Coffee.DailyTotal
    test "with a list of daily diffs" do
      daily_diffs = [
        %DailyTotal{date: ~D[2018-03-27], weight: -450, regular: -400, decaf: -50, unit: "g"},
        %DailyTotal{date: ~D[2018-03-26], weight: -450, regular: -400, decaf: -50, unit: "g"},
        %DailyTotal{date: ~D[2018-03-25], weight: -450, regular: -400, decaf: -50, unit: "g"},
        %DailyTotal{date: ~D[2018-03-24], weight: -450, regular: -400, decaf: -50, unit: "g"},
        %DailyTotal{date: ~D[2018-03-23], weight: -450, regular: -400, decaf: -50, unit: "g"},
        %DailyTotal{date: ~D[2018-03-22], weight: -450, regular: -400, decaf: -50, unit: "g"}
      ]
      total_weight = 5 * -450
      total_regular = 5 * -400
      total_decaf = 5 * -50
      date_range = Date.range(hd(daily_diffs).date, ~D[2018-03-23])
      expected_usage = %DailyTotal{unit: "g", weight: total_weight, regular: total_regular, decaf: total_decaf }
      total_usage = Coffee.total_usage(daily_diffs, date_range)
      assert total_usage.weight == expected_usage.weight
      assert total_usage.regular == expected_usage.regular
      assert total_usage.decaf == expected_usage.decaf
    end
  end
end

