defmodule CoffeeTracker.Coffee.DailyTotal do
  defstruct [:date, :type, :unit, :weight]

  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.DailyTotal

  def get_daily_total!(date) do
    %{weight: total} = total_weight(Coffee.list_daily_measurements(date))
    %DailyTotal{unit: "g", weight: total, date: date}
  end

  @grams_per_pound 454

  defp total_weight(measurements) do
    start = %{unit: "g", weight: 0}
    measurements
    |> Enum.map(&subtract_container/1)
    |> Enum.reduce(start, &add_weight/2)
  end

  defp subtract_container(%{container_id: container_id} = measurement) when is_nil(container_id), do: measurement

  defp subtract_container(%{container_id: container_id} = measurement) do
    container = Coffee.get_container!(container_id)
    subtract_weight(measurement, container)
  end

  defp subtract_weight(%{unit: "g", weight: a}, %{unit: "g", weight: b}) do
    %{unit: "g", weight: a - b}
  end

  defp subtract_weight(%{unit: "lbm", weight: a}, %{unit: "lbm", weight: b} ) do
    %{unit: "lbm", weight: a - b}
  end

  defp subtract_weight(%{unit: "g"} = a, %{unit: "lbm", weight: b} ) do
    subtract_weight(a, %{unit: "g", weight: b * @grams_per_pound})
  end

  defp subtract_weight(%{unit: "lbm", weight: a}, %{unit: "g"} = b ) do
    subtract_weight(%{unit: "g", weight: a * @grams_per_pound}, b)
  end

  defp add_weight(%{unit: "g", weight: a}, %{unit: "g", weight: b}) do
    %{unit: "g", weight: a + b}
  end

  defp add_weight(%{unit: "lbm", weight: a}, %{unit: "g"} = b ) do
    add_weight(%{unit: "g", weight: a * @grams_per_pound}, b)
  end
end
