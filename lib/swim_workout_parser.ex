defmodule GarminWorkoutBuilder.SwimWorkoutParser do
  import GarminWorkoutBuilder.Constants
  @constants constants()

  def metadata?(wo), do: wo |> String.match?(@constants.metadata_regex)

  def swim_warmup?(wo), do: wo |> String.match?(@constants.swim_warmup_regex)

  def swim_repeat?(wo), do: wo |> String.match?(@constants.swim_repeat_regex)

  defp parse_warmup_details(step), do: {step, %{endConditionValue: Regex.run(~r<\d+>, step) |> List.first |> String.to_integer}}

  defp parse_repeat_details(step), do: %{numberOfIterations: Regex.run(~r<\d+>, step) |> List.first |> String.to_integer, steps: []}

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
      step |> swim_warmup? -> Map.merge(%{type: "warmup"}, step |> parse_warmup_details |> parse_extra_details)
      step |> swim_repeat? -> Map.merge(%{type: "repeat"}, step |> parse_repeat_details)
      true -> raise ArgumentError, message: "invalid step, not being able to get parsed correctly"
    end
    parse(steps, acc ++ [encoded_step])
  end

  def parse(steps), do: parse(steps, [])
end
