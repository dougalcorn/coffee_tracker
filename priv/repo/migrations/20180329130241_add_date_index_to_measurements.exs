defmodule CoffeeTracker.Repo.Migrations.AddDateIndexToMeasurements do
  use Ecto.Migration

  def change do
    create index("measurements", [:date])
  end
end
