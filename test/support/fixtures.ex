defmodule CoffeeTracker.Fixtures do
  alias CoffeeTracker.Coffee

  def insert_containers() do
    {:ok, bag} = Coffee.create_container(%{name: "bag", unit: "g", weight: 0})
    {:ok, _cannister} = Coffee.create_container(%{name: "cannister", unit: "g", weight: 450})
    {:ok, _hopper} = Coffee.create_container(%{name: "hopper", unit: "g", weight: 375})
    bag
  end
end
