defmodule CoffeeTracker.Test.Auth do
  import Plug.Conn

  alias CoffeeTracker.Auth.Guardian
  alias CoffeeTracker.Auth

  def authenticate(conn, user, type \\ :access) do
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: type)
    put_req_header(conn, "authorization", "bearer: " <> token)
  end

  def create_user(attributes) do
    {:ok, user} = Auth.create_user(attributes)
    user
  end
end
