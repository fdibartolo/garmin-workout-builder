defmodule GarminWorkoutBuilder do
  @moduledoc """
  Documentation for GarminWorkoutBuilder.
  """

  import GarminWorkoutBuilder.Constants
  @constants constants()

  @doc """
  Hello world.

  ## Examples

      iex> GarminWorkoutBuilder.hello()
      :world

  """
  def hello do
    :world
  end

  def single_swim_repeat?(wo), do: wo |> String.match?(@constants.single_swim_repeat_regex)
end
