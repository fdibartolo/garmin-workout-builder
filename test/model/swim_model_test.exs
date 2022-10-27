defmodule GarminWorkoutBuilder.SwimModelTest do
  use ExUnit.Case

  describe "swim model root structure" do
    test "should include defined keys" do
      assert %GarminWorkoutBuilder.SwimModel{} |> Map.keys |> Enum.filter(fn x -> x != :__struct__ end) == [:avgTrainingSpeed,
        :estimateType, :estimatedDistanceInMeters, :estimatedDistanceUnit, :estimatedDurationInSecs, :poolLength,
        :poolLengthUnit, :sportType, :subSportType, :workoutName, :workoutSegments]
    end

    test "should include default values" do
      assert %GarminWorkoutBuilder.SwimModel{}.poolLength == 25
    end

    test "should include provided values" do
      assert %GarminWorkoutBuilder.SwimModel{workoutName: "testswim"}.workoutName == "testswim"
    end

    test "should include a list of workout segments" do
      assert %GarminWorkoutBuilder.SwimModel{}.workoutSegments |> is_list
    end

    test "should include a list of workout steps within a segment" do
      assert %GarminWorkoutBuilder.SwimModel{}.workoutSegments |> List.first |> Map.fetch!(:workoutSteps) |> is_list
    end
  end

  describe "swim model workout step" do
    test "regular type should have a description field" do
      assert %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{} |> Map.has_key?(:description)
      assert %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{description: "some desc"}.description == "some desc"
    end

    test "regular type should have end condition set to 'distance'" do
      assert %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{}.endCondition.conditionTypeKey == "distance"
    end

    test "regular type should have a stroke type field" do
      assert %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{} |> Map.has_key?(:strokeType)
    end

    test "regular type should have a equipment type field" do
      assert %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{} |> Map.has_key?(:equipmentType)
    end

    test "regular type should not have a workoutSteps field" do
      refute %GarminWorkoutBuilder.SwimModel.RegularWorkoutStep{} |> Map.has_key?(:workoutSteps)
    end

    test "rest type should not have a description field" do
      refute %GarminWorkoutBuilder.SwimModel.RestWorkoutStep{} |> Map.has_key?(:description)
    end

    test "rest type should have step type set to 'rest'" do
      assert %GarminWorkoutBuilder.SwimModel.RestWorkoutStep{}.stepType.stepTypeKey == "rest"
    end

    test "rest type should not have a workoutSteps field" do
      refute %GarminWorkoutBuilder.SwimModel.RestWorkoutStep{} |> Map.has_key?(:workoutSteps)
    end

    test "repeat type should not have a description field" do
      refute %GarminWorkoutBuilder.SwimModel.RepeatWorkoutStep{} |> Map.has_key?(:description)
    end

    test "repeat type should have a numberOfIterations field" do
      assert %GarminWorkoutBuilder.SwimModel.RepeatWorkoutStep{} |> Map.has_key?(:numberOfIterations)
    end

    test "repeat type should have step type set to 'repeat'" do
      assert %GarminWorkoutBuilder.SwimModel.RepeatWorkoutStep{}.stepType.stepTypeKey == "repeat"
    end

    test "repeat type should have end condition set to 'distance'" do
      assert %GarminWorkoutBuilder.SwimModel.RepeatWorkoutStep{}.endCondition.conditionTypeKey == "iterations"
    end

    test "repeat type should not have a workoutSteps field" do
      assert %GarminWorkoutBuilder.SwimModel.RepeatWorkoutStep{} |> Map.has_key?(:workoutSteps)
      assert %GarminWorkoutBuilder.SwimModel.RepeatWorkoutStep{}.workoutSteps |> is_list
    end
  end
end
