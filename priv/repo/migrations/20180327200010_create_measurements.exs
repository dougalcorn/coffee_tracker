defmodule CoffeeTracker.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :unit, :string
      add :weight, :integer
      add :date, :date
      add :type, :string
      add :container_id, references(:containers, on_delete: :nothing)

      timestamps()
    end

    create index(:measurements, [:container_id])
  end
end
