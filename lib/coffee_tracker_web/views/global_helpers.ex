defmodule CoffeeTrackerWeb.GlobalHelpers do

  def display_measurement(%{weight: weight, unit: "g"}) when abs(weight) > 454 do
    display_measurement(%{weight: weight / 454.0, unit: "lbm"})
  end

  def display_measurement(%{weight: weight, unit: "g"}) do
    "#{weight} g"
  end

  def display_measurement(%{weight: weight, unit: "lbm"}) do
    rounded = weight
    |> Decimal.new()
    |> Decimal.round(1)
    "#{rounded} lbm"
  end

  def display_measurement(measurement, %{name: name}) do
    "#{display_measurement(measurement)} #{name}"
  end
end
