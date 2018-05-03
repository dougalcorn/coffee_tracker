defmodule CoffeeTracker.Coffee.TotalUsage do
  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.DailyTotal

  def total_usage(list, date_range) do
    elements_in_range(list, date_range)
    |> Enum.reduce(%DailyTotal{weight: 0, regular: 0, decaf: 0, unit: "g"}, &Coffee.get_daily_sum!/2)
  end

  defp elements_in_range(list, date_range) do
    Enum.filter(list, fn(element) -> Enum.member?(date_range, element.date) end)
  end
end
