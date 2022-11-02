defmodule GarminWorkoutBuilder.SwimWorkoutParser do
  import GarminWorkoutBuilder.Constants
  @constants constants()

  def metadata?(step), do: step |> String.match?(@constants.metadata_regex)

  def swim_warmup?(step), do: step |> String.match?(@constants.swim_warmup_regex)

  def swim_repeat?(step), do: step |> String.match?(@constants.swim_repeat_regex)

  defp single_swim?(step), do: step |> String.match?(@constants.single_swim_regex)

  defp parse_distance_details(step), do: {step, %{endConditionValue: Regex.run(~r<\d+>, step) |> List.first |> String.to_integer}}

  defp cleanup(value, :description), do: String.slice(value, 1..-2)
  defp cleanup(value, _key), do: value

  defp parse_extra_details({step, details}) do
    list = [
      element: @constants.swim_elements_regex,
      description: @constants.swim_description_regex,
      stroke: @constants.swim_stroke_regex
    ]
      |> Enum.map(fn {k,v} -> if (String.match?(step, v)), do: %{k => Regex.run(v, step) |> List.first |> cleanup(k)} end)
      |> Enum.reject(&(&1 == nil))

    unless Enum.empty?(list), do: list |> Enum.reduce(&(Map.merge(&1,&2))) |> Map.merge(details), else: details
  end

  defp parse([], acc), do: acc |> List.flatten
  defp parse([step|steps], acc) do
    encoded_step = cond do
      step |> metadata? -> %{type: "metadata", workoutName: step}
      step |> swim_warmup? -> Map.merge(%{type: "warmup"}, step |> parse_distance_details |> parse_extra_details)
      step |> single_swim? -> Map.merge(%{type: "interval"}, step |> parse_distance_details |> parse_extra_details)
      true -> raise ArgumentError, message: "invalid step, not being able to get parsed correctly"
    end
    parse(steps, acc ++ [encoded_step])
  end

  def parse(steps), do: parse(steps, [])
end
