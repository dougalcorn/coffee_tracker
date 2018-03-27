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

    @valid_attrs %{date: ~D[2010-04-17], type: "some type", unit: "some unit", weight: 42}
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
end
