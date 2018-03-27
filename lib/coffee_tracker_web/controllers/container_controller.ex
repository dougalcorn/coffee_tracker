defmodule CoffeeTrackerWeb.ContainerController do
  use CoffeeTrackerWeb, :controller

  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.Container

  def index(conn, _params) do
    containers = Coffee.list_containers()
    render(conn, "index.html", containers: containers)
  end

  def new(conn, _params) do
    changeset = Coffee.change_container(%Container{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"container" => container_params}) do
    case Coffee.create_container(container_params) do
      {:ok, container} ->
        conn
        |> put_flash(:info, "Container created successfully.")
        |> redirect(to: container_path(conn, :show, container))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    container = Coffee.get_container!(id)
    render(conn, "show.html", container: container)
  end

  def edit(conn, %{"id" => id}) do
    container = Coffee.get_container!(id)
    changeset = Coffee.change_container(container)
    render(conn, "edit.html", container: container, changeset: changeset)
  end

  def update(conn, %{"id" => id, "container" => container_params}) do
    container = Coffee.get_container!(id)

    case Coffee.update_container(container, container_params) do
      {:ok, container} ->
        conn
        |> put_flash(:info, "Container updated successfully.")
        |> redirect(to: container_path(conn, :show, container))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", container: container, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    container = Coffee.get_container!(id)
    {:ok, _container} = Coffee.delete_container(container)

    conn
    |> put_flash(:info, "Container deleted successfully.")
    |> redirect(to: container_path(conn, :index))
  end
end
