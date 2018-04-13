defmodule CoffeeTracker.Repo.Migrations.AddDeliveryToMeasurements do
  use Ecto.Migration

  def change do
    alter table("measurements") do
      add :delivery, :boolean, default: false, null: false
    end
  end
end
