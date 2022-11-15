defmodule GarminWorkoutBuilder do
  @moduledoc """
  Builds workouts for Garmin Connect portal
  """

  def process(steps) do
    steps
    |> GarminWorkoutBuilder.SwimWorkoutParser.parse
    |> GarminWorkoutBuilder.SwimBuilder.build_for
    |> Poison.encode!
  end
end
