defmodule CoffeeTrackerWeb.MeasurementController do
  use CoffeeTrackerWeb, :controller

  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.Measurement

  def index(conn, _params) do
    measurements = Coffee.list_measurements()
    render(conn, "index.html", measurements: measurements)
  end

  def new(conn, _params) do
    changeset = Coffee.change_measurement(%Measurement{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"measurement" => measurement_params}) do
    case Coffee.create_measurement(measurement_params) do
      {:ok, measurement} ->
        conn
        |> put_flash(:info, "Measurement created successfully.")
        |> redirect(to: measurement_path(conn, :show, measurement))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    measurement = Coffee.get_measurement!(id)
    render(conn, "show.html", measurement: measurement)
  end

  def edit(conn, %{"id" => id}) do
    measurement = Coffee.get_measurement!(id)
    changeset = Coffee.change_measurement(measurement)
    render(conn, "edit.html", measurement: measurement, changeset: changeset)
  end

  def update(conn, %{"id" => id, "measurement" => measurement_params}) do
    measurement = Coffee.get_measurement!(id)

    case Coffee.update_measurement(measurement, measurement_params) do
      {:ok, measurement} ->
        conn
        |> put_flash(:info, "Measurement updated successfully.")
        |> redirect(to: measurement_path(conn, :show, measurement))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", measurement: measurement, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    measurement = Coffee.get_measurement!(id)
    {:ok, _measurement} = Coffee.delete_measurement(measurement)

    conn
    |> put_flash(:info, "Measurement deleted successfully.")
    |> redirect(to: measurement_path(conn, :index))
  end
end