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
    Enum.reduce(measurements, start, &add_weight/2)
  end

  defp add_weight(%{unit: "g", weight: a}, %{unit: "g", weight: b}) do
    %{unit: "g", weight: a + b}
  end

  defp add_weight(%{unit: "lbm", weight: a}, %{unit: "g"} = b ) do
    add_weight(%{unit: "g", weight: a * @grams_per_pound}, b)
  end
end
