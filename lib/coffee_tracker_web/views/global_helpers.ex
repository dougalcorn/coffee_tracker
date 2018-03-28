defmodule CoffeeTrackerWeb.GlobalHelpers do

  def display_measurement(%{weight: weight, unit: unit}, nil) do
    "#{weight} #{unit}"
  end

  def display_measurement(measurement, %{name: name}) do
    "#{display_measurement(measurement, nil)} #{name}"
  end
end
