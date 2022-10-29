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

  test "should include cooldown step given any stroke details", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "cooldown", stroke: "any", endConditionValue: 200}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
      assert steps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "cooldown"
      assert steps |> List.first |> Map.fetch!(:strokeType) |> Map.fetch!(:strokeTypeKey) == "any_stroke"
      assert steps |> List.first |> Map.fetch!(:endConditionValue) == 200
  end

  test "should include interval step given distance details, free stroke by default", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "interval", endConditionValue: 500}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
      assert steps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "interval"
      assert steps |> List.first |> Map.fetch!(:strokeType) |> Map.fetch!(:strokeTypeKey) == "free"
      assert steps |> List.first |> Map.fetch!(:endConditionValue) == 500
  end

  test "should include interval step given paddle equipment details", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "interval", element: "MP"}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
      assert steps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "interval"
      assert steps |> List.first |> Map.fetch!(:equipmentType) |> Map.fetch!(:equipmentTypeKey) == "paddles"
  end

  test "should include interval step given pullbuoy equipment details", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "interval", element: "PB"}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
      assert steps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "interval"
      assert steps |> List.first |> Map.fetch!(:equipmentType) |> Map.fetch!(:equipmentTypeKey) == "pull_buoy"
  end

  test "should include rest step with lap button", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "rest", endCondition: "lap.button"}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
      assert steps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "rest"
      assert steps |> List.first |> Map.fetch!(:endCondition) |> Map.fetch!(:conditionTypeKey) == "lap.button"
  end

  test "should include rest step with fixed time", context do
    steps = GarminWorkoutBuilder.SwimBuilder.build_for([context.metadata, %{type: "rest", endCondition: "fixed", endConditionValue: 30}]).workoutSegments
      |> List.first |> Map.fetch!(:workoutSteps)
      assert steps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "rest"
      assert steps |> List.first |> Map.fetch!(:endCondition) |> Map.fetch!(:conditionTypeKey) == "fixed.rest"
      assert steps |> List.first |> Map.fetch!(:endConditionValue) == 30
  end

  test "should combine full workout without repeats", context do
    list = [
      context.metadata,
      %{type: "warmup", endConditionValue: 400, description: "easy", element: "SNKL"},
      %{type: "rest", endCondition: "fixed", endConditionValue: 40},
      %{type: "interval", endConditionValue: 800, element: "PB"},
      %{type: "rest", endCondition: "lap.button"},
      %{type: "cooldown", stroke: "any", endConditionValue: 100, element: "FINS"}
    ]
    steps = GarminWorkoutBuilder.SwimBuilder.build_for(list).workoutSegments |> List.first |> Map.fetch!(:workoutSteps)
    assert steps |> Enum.count == 5
    interval = Enum.find(steps, fn s -> s.stepType.stepTypeKey == "interval" end)
    assert interval.endConditionValue == 800
    assert interval.strokeType.strokeTypeKey == "free" # free by default
    assert interval.equipmentType.equipmentTypeKey == "pull_buoy"
  end

  test "should include interval step within a repeat step", context do
    list = [
      context.metadata,
      %{type: "repeat", numberOfIterations: 8, steps: [
        %{type: "interval", endConditionValue: 50, stroke: "drill"},
        %{type: "rest", endCondition: "fixed", endConditionValue: 10}
      ]}
    ]
    steps = GarminWorkoutBuilder.SwimBuilder.build_for(list).workoutSegments |> List.first |> Map.fetch!(:workoutSteps)
    assert steps |> Enum.count == 1
    repeat_step = steps |> List.first
    assert repeat_step.stepType.stepTypeKey == "repeat"
    assert repeat_step.numberOfIterations == 8
    assert repeat_step.workoutSteps |> Enum.count == 2
    assert repeat_step.workoutSteps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "interval"
    assert repeat_step.workoutSteps |> List.last |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "rest"
  end

  test "should include interval step within a repeat step, within another repeat step", context do
    list = [
      context.metadata,
      %{type: "repeat", numberOfIterations: 3, steps: [
        %{type: "repeat", numberOfIterations: 8, steps: [
          %{type: "interval", endConditionValue: 50, stroke: "drill"},
          %{type: "rest", endCondition: "fixed", endConditionValue: 10}
        ]},
        %{type: "rest", endCondition: "fixed", endConditionValue: 60}
      ]}
    ]
    steps = GarminWorkoutBuilder.SwimBuilder.build_for(list).workoutSegments |> List.first |> Map.fetch!(:workoutSteps)
    assert steps |> Enum.count == 1
    first_repeat_step = steps |> List.first
    assert first_repeat_step.stepType.stepTypeKey == "repeat"
    assert first_repeat_step.numberOfIterations == 3
    assert first_repeat_step.workoutSteps |> Enum.count == 2
    assert first_repeat_step.workoutSteps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "repeat"
    assert first_repeat_step.workoutSteps |> List.last |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "rest"
    assert first_repeat_step.workoutSteps |> List.last |> Map.fetch!(:endConditionValue) == 60
    second_repeat_step = first_repeat_step.workoutSteps |> List.first
    assert second_repeat_step.numberOfIterations == 8
    assert second_repeat_step.workoutSteps |> Enum.count == 2
    assert second_repeat_step.workoutSteps |> List.first |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "interval"
    assert second_repeat_step.workoutSteps |> List.last |> Map.fetch!(:stepType) |> Map.fetch!(:stepTypeKey) == "rest"
    assert second_repeat_step.workoutSteps |> List.last |> Map.fetch!(:endConditionValue) == 10
  end
end
