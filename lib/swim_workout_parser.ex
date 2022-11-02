defmodule GarminWorkoutBuilder.SwimWorkoutParser do
  import GarminWorkoutBuilder.Constants
  @constants constants()

  def metadata?(step), do: step |> String.match?(@constants.metadata_regex)

  def swim_warmup?(step), do: step |> String.match?(@constants.swim_warmup_regex)

  def swim_repeat?(step), do: step |> String.match?(@constants.swim_repeat_regex)

  defp single_swim?(step), do: step |> String.match?(@constants.single_swim_regex)

  defp fixed_rest?(step), do: step |> String.match?(@constants.swim_rest_regex)

  defp parse_distance_details(step), do: {step, %{endConditionValue: Regex.run(~r<\d+>, step) |> List.first |> String.to_integer}}

  defp parse_rest_details(step), do: %{endConditionValue: step |> String.trim_trailing("'") |> String.to_integer}

  defp add_repeat_extra_details_to_intervals(steps, details), do:
    Enum.map(steps, &(if (fixed_rest?(&1)), do: &1, else: "#{&1} #{details}"))

  defp parse_repeat_details(step) do
    intervals = Regex.run(~r<\(.*?\[>, step) |> List.first |> String.slice(1..-2) |> String.split
    rest = Regex.run(~r<\d+''>, step) |> List.first
    extra_details = step |> String.trim_leading(Regex.run(@constants.swim_repeat_regex, step) |> List.first)
    raw_steps = intervals |> Enum.join(" #{rest} ") |> String.split |> List.insert_at(-1,rest)

    %{
      numberOfIterations: Regex.run(~r<\d+>, step) |> List.first |> String.to_integer,
      steps: raw_steps |> add_repeat_extra_details_to_intervals(extra_details) |> parse
    }
  end

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
      step |> swim_repeat? -> Map.merge(%{type: "repeat"}, step |> parse_repeat_details)
      step |> fixed_rest? -> Map.merge(%{type: "rest", endCondition: "fixed"}, step |> parse_rest_details)
      step |> single_swim? -> Map.merge(%{type: "interval"}, step |> parse_distance_details |> parse_extra_details)
      true -> raise ArgumentError, message: "invalid step, not being able to get parsed correctly"
    end
    parse(steps, acc ++ [encoded_step])
  end

  def parse(steps), do: parse(steps, [])
end
