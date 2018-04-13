defmodule CoffeeTracker.Coffee.Measurement do
  use Ecto.Schema
  import Ecto.Changeset


  schema "measurements" do
    field :date, :date
    field :type, :string
    field :unit, :string
    field :weight, :integer
    field :delivery, :boolean
    belongs_to :container, CoffeeTracker.Coffee.Container

    timestamps()
  end

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [:unit, :weight, :date, :type, :container_id, :delivery])
    |> validate_required([:unit, :weight, :date, :type])
  end
end
