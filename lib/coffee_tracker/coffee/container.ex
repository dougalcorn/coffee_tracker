defmodule CoffeeTracker.Coffee.Container do
  use Ecto.Schema
  import Ecto.Changeset


  schema "containers" do
    field :name, :string
    field :unit, :string
    field :weight, :integer

    timestamps()
  end

  @doc false
  def changeset(container, attrs) do
    container
    |> cast(attrs, [:weight, :unit, :name])
    |> validate_required([:weight, :unit, :name])
  end
end
