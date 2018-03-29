defmodule CoffeeTrackerWeb.MeasurementControllerTest do
  use CoffeeTrackerWeb.ConnCase

  alias CoffeeTracker.Coffee

  @create_attrs %{date: ~D[2010-04-17], type: "some type", unit: "some unit", weight: 42}
  @update_attrs %{date: ~D[2011-05-18], type: "some updated type", unit: "some updated unit", weight: 43}
  @invalid_attrs %{date: nil, type: nil, unit: nil, weight: nil}

  def fixture(:measurement) do
    {:ok, measurement} = Coffee.create_measurement(@create_attrs)
    measurement
  end

  def show_path(conn, %{date: date}) do
    daily_summary_path(conn, :show, date.year, date.month, date.day)
  end

  alias CoffeeTracker.Auth.Guardian
  alias CoffeeTracker.Auth

  setup %{conn: conn} do
    {:ok, user} = Auth.create_user(%{username: "doug", password: "pass"})
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)
    conn = put_req_header(conn, "authorization", "bearer: " <> token)
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all measurements", %{conn: conn} do
      conn = get conn, measurement_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Measurements"
    end
  end

  describe "new measurement" do
    test "renders form", %{conn: conn} do
      conn = get conn, measurement_path(conn, :new)
      assert html_response(conn, 200) =~ "New Measurement"
    end
  end

  describe "create measurement" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, measurement_path(conn, :create), measurement: @create_attrs

      assert redirected_to(conn) == show_path(conn, @create_attrs)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, measurement_path(conn, :create), measurement: @invalid_attrs
      assert html_response(conn, 200) =~ "New Measurement"
    end
  end

  describe "edit measurement" do
    setup [:create_measurement]

    test "renders form for editing chosen measurement", %{conn: conn, measurement: measurement} do
      conn = get conn, measurement_path(conn, :edit, measurement)
      assert html_response(conn, 200) =~ "Edit Measurement"
    end
  end

  describe "update measurement" do
    setup [:create_measurement]

    test "redirects when data is valid", %{conn: conn, measurement: measurement} do
      response = put conn, measurement_path(conn, :update, measurement), measurement: @update_attrs
      assert redirected_to(response) == show_path(conn, @update_attrs)

      response = get conn, measurement_path(conn, :show, measurement)
      assert html_response(response, 200) =~ "some updated type"
    end

    test "renders errors when data is invalid", %{conn: conn, measurement: measurement} do
      conn = put conn, measurement_path(conn, :update, measurement), measurement: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Measurement"
    end
  end

  describe "delete measurement" do
    setup [:create_measurement]

    test "deletes chosen measurement", %{conn: conn, measurement: measurement} do
      response = delete conn, measurement_path(conn, :delete, measurement)
      assert redirected_to(response) == show_path(conn, measurement)
      assert_error_sent 404, fn ->
        get conn, measurement_path(conn, :show, measurement)
      end
    end
  end

  defp create_measurement(_) do
    measurement = fixture(:measurement)
    {:ok, measurement: measurement}
  end
end
