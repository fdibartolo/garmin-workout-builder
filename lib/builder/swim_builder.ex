defmodule GarminWorkoutBuilder.SwimBuilder do
  @moduledoc """
  Builds swim workout to be encoded as a json payload
  """
  import GarminWorkoutBuilder.Constants
  @constants constants()

  defp extract_field(map, key) do
    case Map.fetch(map, key) do
      {:ok, v} -> v
      :error -> nil
    end
  end

  defp build_stroke_type_for(type) do
    stroke = case type do
      "drill" -> {@constants.swim_stroke_type_drill_id, @constants.swim_stroke_type_drill_key}
      "any" -> {@constants.swim_stroke_type_any_id, @constants.swim_stroke_type_any_key}
      _ -> {@constants.swim_stroke_type_free_id, @constants.swim_stroke_type_free_key} # free for default
    end
    %GarminWorkoutBuilder.SwimModel.StrokeType{strokeTypeId: elem(stroke, 0), strokeTypeKey: elem(stroke, 1)}
  end

  defp build_step_type_for("warmup"), do: %GarminWorkoutBuilder.SwimModel.RegularStepType{
    stepTypeId: @constants.swim_step_type_warmup_id, stepTypeKey: @constants.swim_step_type_warmup_key}
  defp build_step_type_for("cooldown"), do: %GarminWorkoutBuilder.SwimModel.RegularStepType{
    stepTypeId: @constants.swim_step_type_cooldown_id, stepTypeKey: @constants.swim_step_type_cooldown_key}

  defp build_workout_step_for(type, data) when type in ~w(warmup cooldown) do
    %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{
      stepType: build_step_type_for(type),
      strokeType: build_stroke_type_for(data |> extract_field(:stroke)),
      endConditionValue: data |> extract_field(:endConditionValue),
      description: data |> extract_field(:description)
    }
  end

  def build_for([], acc), do: acc
  def build_for([step|steps], acc) do
    workout_step = build_workout_step_for(step.type, step)
    build_for(steps, acc ++ workout_step)
  end
  def build_for([step|steps]) do
    root = %GarminWorkoutBuilder.SwimModel{}
    root = %{root | workoutName: step.workoutName} # should actually check if it is the metadata step, first one of the list
    workout_steps = build_for(steps, [])

    segments = %GarminWorkoutBuilder.SwimModel.WorkoutSegment{workoutSteps: [workout_steps]}
    %{root | workoutSegments: [segments]}
  end
end
