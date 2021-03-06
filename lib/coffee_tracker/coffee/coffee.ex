defmodule CoffeeTracker.Coffee do
  @moduledoc """
  The Coffee context.
  """

  import Ecto.Query, warn: false
  alias CoffeeTracker.Repo
  alias CoffeeTracker.Coffee
  alias CoffeeTracker.Coffee.Measurement
  alias CoffeeTracker.Coffee.DailyTotal

  alias CoffeeTracker.Coffee.CoffeeContainer
  defdelegate list_containers, to: CoffeeContainer
  defdelegate get_container!(id), to: CoffeeContainer
  defdelegate create_container(attrs), to: CoffeeContainer
  defdelegate update_container(container, attrs), to: CoffeeContainer
  defdelegate delete_container(container), to: CoffeeContainer
  defdelegate change_container(container), to: CoffeeContainer

  alias CoffeeTracker.Coffee.CoffeeMeasurement
  defdelegate list_measurements, to: CoffeeMeasurement
  defdelegate get_measurement!(id), to: CoffeeMeasurement
  defdelegate create_measurement(attrs), to: CoffeeMeasurement
  defdelegate update_measurement(measurement, attrs), to: CoffeeMeasurement
  defdelegate delete_measurement(measurement), to: CoffeeMeasurement
  defdelegate change_measurement(measurement), to: CoffeeMeasurement


  @doc """
  Returns a list of dates for which there are measurements
  """
  def list_measurement_dates() do
    query = from m in Measurement,
      select: m.date,
      limit: 21,
      order_by: [desc: m.date],
      distinct: true
    Repo.all(query)
  end

  @doc """
  Returns the list of measurements for a given Date.
  """
  def list_daily_measurements(date) do
    preloader = fn(_ids) -> Coffee.list_containers() end
    query = from m in Measurement,
      where: m.date == ^date,
      preload: [container: ^preloader],
      join: c in assoc(m, :container),
      order_by: [desc: m.type,asc: m.inserted_at]
    Repo.all(query)
  end
  def list_daily_delivery_measurements(date) do
    list_daily_measurements(date)
    |> Enum.filter(fn(m) -> m.delivery == true end)
  end

  @doc """
  Gets a the total amount of coffee on a given day.

  Raises `Ecto.NoResultsError` if there are no measurements for that day.

  ## Examples

  iex> get_daily_total!(~D[03/28/2018])
  %DailyTotal{}

  iex> get_daily_total!(~D[03/31/2018])
  ** (Ecto.NoResultsError)

  """
  def get_daily_total!(date), do: DailyTotal.get_daily_total!(date)
  def get_daily_delivery_total!(date), do: DailyTotal.get_daily_delivery_total!(date)

  defdelegate get_daily_sum!(a, b), to: DailyTotal
  defdelegate get_daily_diff!(today_total, prev_total), to: DailyTotal
  defdelegate get_daily_diff!(today_total, prev_total, delivery_total), to: DailyTotal

  @doc """
  Returns the list of daily totals for all of the dates for which there are measurements.
  """
  def list_daily_totals() do
    list_measurement_dates()
    |> Enum.map(&get_daily_total!/1)
  end

  def list_daily_delivery_totals() do
    list_measurement_dates()
    |> Enum.map(&get_daily_delivery_total!/1)
  end

  def list_daily_diffs(daily_totals) do
    list_daily_diffs(daily_totals, Coffee.list_daily_delivery_totals())
  end

  def list_daily_diffs(daily_totals, delivery_totals) do
    for daily_total <- daily_totals do
      previous = prev_daily_total(daily_totals, daily_total)
      delivery_total = delivery_total(delivery_totals, daily_total)
      DailyTotal.get_daily_diff!(daily_total, previous, delivery_total)
    end
  end

  defp prev_daily_total(daily_totals, daily_total) do
    Enum.find(daily_totals, fn(d) -> Date.compare(d.date, daily_total.date) == :lt end)
  end

  defp delivery_total(_delivery_totals, nil), do: nil
  defp delivery_total(delivery_totals, %{date: date}) do
    Enum.find(delivery_totals, fn(d) -> Date.compare(d.date, date) == :eq end)
  end

  defdelegate total_usage(list, date_range), to: CoffeeTracker.Coffee.TotalUsage
end
