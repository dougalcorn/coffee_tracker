defmodule CoffeeTracker.Coffee.DailyTotal do
  defstruct [:date, :type, :unit, :weight]

  require Ecto.Query
  alias CoffeeTracker.Coffee.DailyTotal

  def get_daily_total!(date) do
    %{weight: total} = total_weight(daily_measurements(date))
    %DailyTotal{unit: "g", weight: total}
  end


  defp daily_measurements(date) do
    CoffeeTracker.Coffee.Measurement
    |> Ecto.Query.where(date: ^date)
    |> CoffeeTracker.Repo.all
  end

  defp total_weight(measurements) do
    start = %{unit: "g", weight: 0}
    Enum.reduce(measurements, start, &add_weight/2)
  end

  defp add_weight(%{unit: "g", weight: a}, %{unit: "g", weight: b}) do
    %{unit: "g", weight: a + b}
  end

  defp add_weight(%{unit: "lbm", weight: a}, %{unit: "g", weight: b}) do
    total = (a * 2268) + b
    %{unit: "g", weight: total}
  end
end
