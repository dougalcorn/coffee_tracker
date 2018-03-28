defmodule CoffeeTrackerWeb.GlobalHelpers do

  def display_measurement(%{weight: weight, unit: "g"}, nil) when weight > 454 do
    display_measurement(%{weight: weight / 454.0, unit: "lbm"}, nil)
  end

  def display_measurement(%{weight: weight, unit: "g"}, nil) do
    "#{weight} g"
  end

  def display_measurement(%{weight: weight, unit: "lbm"}, nil) do
    rounded = weight
    |> Decimal.new()
    |> Decimal.round(1)
    "#{rounded} lbm"
  end

  def display_measurement(measurement, %{name: name}) do
    "#{display_measurement(measurement, nil)} #{name}"
  end
end
