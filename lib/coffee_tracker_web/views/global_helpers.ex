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

  def display_shipment_icon(%{delivery: false}), do: ""
  def display_shipment_icon(%{delivery: true}) do
    Phoenix.HTML.Tag.img_tag(CoffeeTrackerWeb.Endpoint.static_path("/images/delivery.png"), class: "small-icon")
  end
end
