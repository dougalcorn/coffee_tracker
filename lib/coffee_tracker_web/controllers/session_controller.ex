defmodule CoffeeTrackerWeb.SessionController do
  use CoffeeTrackerWeb, :controller

  alias CoffeeTracker.Auth
  alias CoffeeTracker.Auth.User
  alias CoffeeTracker.Auth.Guardian

  def new(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    message = if maybe_user != nil do
      "Someone is logged in"
    else
      "No one is logged in"
    end

    render conn, "new.html", changeset: changeset, action: session_path(conn, :create), maybe_user: maybe_user
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Auth.authenticate_user(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> new(%{})
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: daily_summary_path(conn, :index))
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logout successful.")
    |> redirect(to: daily_summary_path(conn, :index))
  end
end
