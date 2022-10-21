defmodule GarminWorkoutBuilder.SwimWorkoutParser do
  import GarminWorkoutBuilder.Constants
  @constants constants()

  def single_swim_repeat?(wo), do: wo |> String.match?(@constants.single_swim_repeat_regex)
end
