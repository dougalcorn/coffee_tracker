defmodule CoffeeTrackerWeb.ContainerControllerTest do
  use CoffeeTrackerWeb.ConnCase

  alias CoffeeTracker.Coffee

  @create_attrs %{name: "some name", unit: "some unit", weight: 42}
  @update_attrs %{name: "some updated name", unit: "some updated unit", weight: 43}
  @invalid_attrs %{name: nil, unit: nil, weight: nil}

  def fixture(:container) do
    {:ok, container} = Coffee.create_container(@create_attrs)
    container
  end

  import CoffeeTracker.Test.Auth

  setup %{conn: conn} do
    user = create_user(%{username: "doug", password: "pass"})
    {:ok, conn: authenticate(conn, user), user: user}
  end

  describe "index" do
    test "lists all containers", %{conn: conn} do
      conn = get conn, container_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Containers"
    end
  end

  describe "new container" do
    test "renders form", %{conn: conn} do
      conn = get conn, container_path(conn, :new)
      assert html_response(conn, 200) =~ "New Container"
    end
  end

  describe "create container" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, container_path(conn, :create), container: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == container_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, container_path(conn, :create), container: @invalid_attrs
      assert html_response(conn, 200) =~ "New Container"
    end
  end

  describe "edit container" do
    setup [:create_container]

    test "renders form for editing chosen container", %{conn: conn, container: container} do
      conn = get conn, container_path(conn, :edit, container)
      assert html_response(conn, 200) =~ "Edit Container"
    end
  end

  describe "update container" do
    setup [:create_container]

    test "redirects when data is valid", %{conn: conn, container: container} do
      conn = put conn, container_path(conn, :update, container), container: @update_attrs
      assert redirected_to(conn) == container_path(conn, :show, container)
    end

    test "renders errors when data is invalid", %{conn: conn, container: container} do
      conn = put conn, container_path(conn, :update, container), container: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Container"
    end
  end

  describe "delete container" do
    setup [:create_container]

    test "deletes chosen container", %{conn: conn, container: container} do
      response = delete conn, container_path(conn, :delete, container)
      assert redirected_to(response) == container_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, container_path(conn, :show, container)
      end
    end
  end

  defp create_container(_) do
    container = fixture(:container)
    {:ok, container: container}
  end
end
