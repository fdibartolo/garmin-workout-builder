defmodule GarminWorkoutBuilder.SwimBuilderTest do
  use ExUnit.Case

  setup do
    %{metadata: %{type: "metadata", workoutName: "foobar workout"}}
  end

  test "should build basic structure with provided root fields", context do
    result = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata])
    assert result |> is_map
    assert result.sportType.sportTypeKey == "swimming"
    assert result.workoutName == "foobar workout"
  end

  test "should include a warmup step", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "warmup"}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
    assert steps |> Enum.count == 1
    assert steps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "warmup"
  end

  test "should include warmup step given distance details", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "warmup", endConditionValue: 400, description: "easy"}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
    assert steps |> List.first |> Map.fetch!(:endConditionValue) == 400
    assert steps |> List.first |> Map.fetch!(:description) == "easy"
  end

  test "should include warmup step given free stroke details", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "warmup", stroke: "free"}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
    assert steps |> List.first |> Map.fetch!(:strokeType) |> Map.fetch!(:strokeTypeKey) == "free"
  end

  test "should include warmup step given drill stroke details", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "warmup", stroke: "drill"}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
    assert steps |> List.first |> Map.fetch!(:strokeType) |> Map.fetch!(:strokeTypeId) == 4
  end
end
