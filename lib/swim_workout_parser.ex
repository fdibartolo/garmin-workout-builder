defmodule GarminWorkoutBuilder.SwimWorkoutParser do
  import GarminWorkoutBuilder.Constants
  @constants constants()

  def metadata?(wo), do: wo |> String.match?(@constants.metadata_regex)

  def swim_warmup?(wo), do: wo |> String.match?(@constants.swim_warmup_regex)

  def single_swim_repeat?(wo), do: wo |> String.match?(@constants.single_swim_repeat_regex)
end
