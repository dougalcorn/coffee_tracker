defmodule CoffeeTracker.Repo.Migrations.CreateContainers do
  use Ecto.Migration

  def change do
    create table(:containers) do
      add :weight, :integer
      add :unit, :string
      add :name, :string

      timestamps()
    end

  end
end
