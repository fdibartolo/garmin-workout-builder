defmodule GarminWorkoutBuilder.SwimWorkoutParser do
  import GarminWorkoutBuilder.Constants
  @constants constants()

  def metadata?(wo), do: wo |> String.match?(@constants.metadata_regex)

  def swim_warmup?(wo), do: wo |> String.match?(@constants.swim_warmup_regex)

  def single_swim_repeat?(wo), do: wo |> String.match?(@constants.single_swim_repeat_regex)

  defp parse_warmup_details(step), do: {step, %{endConditionValue: Regex.run(~r<\d+>, step) |> List.first |> String.to_integer}}

  defp parse_element_details({step, details}) do
    cond do
      step |> String.match?(@constants.swim_elements_regex) ->
        {step, Map.merge(details, %{element: Regex.run(@constants.swim_elements_regex, step) |> List.first})}
      true -> {step, details}
    end
  end

  defp parse([], acc), do: acc |> List.flatten
  defp parse([step|steps], acc) do
    encoded_step = cond do
      step |> metadata? -> %{type: "metadata", workoutName: step}
      step |> swim_warmup? -> Map.merge(%{type: "warmup"}, step |> parse_warmup_details |> parse_element_details |> elem(1))
      true -> raise ArgumentError, message: "invalid step, not being able to get parsed correctly"
    end
    parse(steps, acc ++ [encoded_step])
  end

  def parse(steps), do: parse(steps, [])
end
