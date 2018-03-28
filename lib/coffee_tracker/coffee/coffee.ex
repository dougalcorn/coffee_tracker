defmodule CoffeeTracker.Coffee do
  @moduledoc """
  The Coffee context.
  """

  import Ecto.Query, warn: false
  alias CoffeeTracker.Repo

  alias CoffeeTracker.Coffee.DailyTotal

  def list_daily_totals() do
    [get_daily_total!(Date.utc_today)]
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

  alias CoffeeTracker.Coffee.Container

  @doc """
  Returns the list of containers.

  ## Examples

      iex> list_containers()
      [%Container{}, ...]

  """
  def list_containers do
    Repo.all(Container)
  end

  @doc """
  Gets a single container.

  Raises `Ecto.NoResultsError` if the Container does not exist.

  ## Examples

      iex> get_container!(123)
      %Container{}

      iex> get_container!(456)
      ** (Ecto.NoResultsError)

  """
  def get_container!(id), do: Repo.get!(Container, id)

  @doc """
  Creates a container.

  ## Examples

      iex> create_container(%{field: value})
      {:ok, %Container{}}

      iex> create_container(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_container(attrs \\ %{}) do
    %Container{}
    |> Container.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a container.

  ## Examples

      iex> update_container(container, %{field: new_value})
      {:ok, %Container{}}

      iex> update_container(container, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_container(%Container{} = container, attrs) do
    container
    |> Container.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Container.

  ## Examples

      iex> delete_container(container)
      {:ok, %Container{}}

      iex> delete_container(container)
      {:error, %Ecto.Changeset{}}

  """
  def delete_container(%Container{} = container) do
    Repo.delete(container)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking container changes.

  ## Examples

      iex> change_container(container)
      %Ecto.Changeset{source: %Container{}}

  """
  def change_container(%Container{} = container) do
    Container.changeset(container, %{})
  end

  alias CoffeeTracker.Coffee.Measurement

  @doc """
  Returns the list of measurements.

  ## Examples

      iex> list_measurements()
      [%Measurement{}, ...]

  """
  def list_measurements do
    Repo.all(Measurement)
  end

  @doc """
  Returns the list of measurements for a given Date.
  """
  def list_daily_measurements(date) do
    CoffeeTracker.Coffee.Measurement
    |> Ecto.Query.where(date: ^date)
    |> CoffeeTracker.Repo.all
  end

  @doc """
  Gets a single measurement.

  Raises `Ecto.NoResultsError` if the Measurement does not exist.

  ## Examples

      iex> get_measurement!(123)
      %Measurement{}

      iex> get_measurement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_measurement!(id), do: Repo.get!(Measurement, id)

  @doc """
  Creates a measurement.

  ## Examples

      iex> create_measurement(%{field: value})
      {:ok, %Measurement{}}

      iex> create_measurement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_measurement(attrs \\ %{}) do
    %Measurement{}
    |> Measurement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a measurement.

  ## Examples

      iex> update_measurement(measurement, %{field: new_value})
      {:ok, %Measurement{}}

      iex> update_measurement(measurement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_measurement(%Measurement{} = measurement, attrs) do
    measurement
    |> Measurement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Measurement.

  ## Examples

      iex> delete_measurement(measurement)
      {:ok, %Measurement{}}

      iex> delete_measurement(measurement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_measurement(%Measurement{} = measurement) do
    Repo.delete(measurement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking measurement changes.

  ## Examples

      iex> change_measurement(measurement)
      %Ecto.Changeset{source: %Measurement{}}

  """
  def change_measurement(%Measurement{} = measurement) do
    Measurement.changeset(measurement, %{})
  end
end
