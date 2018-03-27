defmodule CoffeeTrackerWeb.MeasurementView do
  use CoffeeTrackerWeb, :view

  alias CoffeeTracker.Repo
  alias CoffeeTracker.Coffee.Container
  import Ecto.Query, only: [from: 2]

  def containers() do
     Repo.all(from(c in Container, select: {c.name, c.id}))
  end
end
