defmodule CoffeeTracker.Coffee.DailyTotal do
  defstruct [:date, :unit, :weight, :regular, :decaf]

  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.DailyTotal

  def get_daily_total!(date) do
    get_daily_total!(date, Coffee.list_daily_measurements(date))
  end

  def get_daily_total!(date, measurements) do
    %{weight: total} = total_weight(measurements)
    %{weight: regular} = total_weight(Enum.filter(measurements, fn(x) -> x.type == "Regular" end))
    %{weight: decaf} = total_weight(Enum.filter(measurements, fn(x) -> x.type == "Decaf" end))
    %DailyTotal{unit: "g", weight: total, date: date, regular: regular, decaf: decaf}
  end

  def get_daily_delivery_total!(date) do
    get_daily_total!(date, Coffee.list_daily_delivery_measurements(date))
  end

  def get_daily_diff!(daily_total, nil) do
    %DailyTotal{unit: daily_total.unit, date: daily_total.date, weight: 0, regular: 0, decaf: 0}
  end
  def get_daily_diff!(daily_total, prev_total) do
    %{weight: diff} = subtract_weight(daily_total, prev_total)
    %{weight: r_diff} = subtract_weight(regular_weight(daily_total), regular_weight(prev_total))
    %{weight: d_diff} = subtract_weight(decaf_weight(daily_total), decaf_weight(prev_total))
    %DailyTotal{unit: daily_total.unit, date: daily_total.date, weight: diff, regular: r_diff, decaf: d_diff}
  end

  def get_daily_diff!(daily_total, prev_total, nil), do: get_daily_diff!(daily_total, prev_total)
  def get_daily_diff!(daily_total, prev_total, delivery_total) do
    today_minus_delivery = get_daily_diff!(daily_total, delivery_total)
    get_daily_diff!(today_minus_delivery, prev_total)
  end

  defp regular_weight(%{unit: unit, regular: regular}) do
    %{unit: unit, weight: regular}
  end

  defp decaf_weight(%{unit: unit, decaf: decaf}) do
    %{unit: unit, weight: decaf}
  end

  @grams_per_pound 454

  defp total_weight(measurements) do
    start = %{unit: "g", weight: 0}
    measurements
    |> Enum.map(&subtract_container/1)
    |> Enum.reduce(start, &add_weight/2)
  end

  defp subtract_container(%{container_id: container_id} = measurement) when is_nil(container_id), do: measurement

  defp subtract_container(%{container_id: container_id, container: container} = measurement) when is_nil(container) do
    container = Coffee.get_container!(container_id)
    subtract_weight(measurement, container)
  end

  defp subtract_container(%{container: container} = measurement) do
    subtract_weight(measurement, container)
  end

  defp subtract_weight(nil, nil), do: %{weight: nil}
  defp subtract_weight(%{weight: nil}, %{weight: nil}), do: %{weight: nil}
  defp subtract_weight(%{weight: a}, nil), do: %{weight: a}
  defp subtract_weight(%{weight: a}, %{weight: nil}), do: %{weight: a}
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
