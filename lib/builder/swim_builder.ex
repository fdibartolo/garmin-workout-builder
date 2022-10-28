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

  defp build_step_for("warmup", data) do
    type = %GarminWorkoutBuilder.SwimModel.RegularStepType{
      stepTypeId: @constants.swim_step_type_warmup_id,
      stepTypeKey: @constants.swim_step_type_warmup_key
    }
    %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{
      stepType: type,
      endConditionValue: data |> extract_field(:endConditionValue),
      description: data |> extract_field(:description)
    }
  end

  def build_for([], acc), do: acc
  def build_for([step|steps], acc) do
    workout_step = build_step_for(step.type, step)
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
