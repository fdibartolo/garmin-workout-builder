defmodule GarminWorkoutBuilder.SwimWorkoutParserTest do
  use ExUnit.Case

  @metadata "T3P2S1D7"
  @swim_warmup "400 e/c"
  @swim_elements "MP"
  @swim_step_description "<prog>"
  @swim_stroke "drill"
  @single_swim "800"
  @single_swim_repeat "15x(100 [20''])"
  @double_swim_repeat "15x(100 75 [20''])"

  describe "parse" do
    test "should raise exception when workout step cannot be parsed" do
      assert_raise ArgumentError, ~r/invalid step/, fn ->
        GarminWorkoutBuilder.SwimWorkoutParser.parse(["bad data"])
      end
    end

    test "should create list with metadata info" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse([@metadata]) == [%{type: "metadata", workoutName: @metadata}]
    end

    test "should create list with warmup info" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse([@swim_warmup]) == [%{type: "warmup", endConditionValue: 400}]
    end

    test "should create list with warmup info and elements" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse(["#{@swim_warmup} #{@swim_elements}"]) ==
        [%{type: "warmup", endConditionValue: 400, element: "MP"}]
    end

    test "should create list with warmup info and description" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse(["#{@swim_warmup} #{@swim_step_description}"]) ==
        [%{type: "warmup", endConditionValue: 400, description: "prog"}]
    end

    test "should create list with warmup info and stroke type" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse(["#{@swim_warmup} #{@swim_stroke}"]) ==
        [%{type: "warmup", endConditionValue: 400, stroke: "drill"}]
    end

    test "should create list with interval info" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse([@single_swim]) == [%{type: "interval", endConditionValue: 800}]
    end

    test "should create list with interval info plus elements and stroke details" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse(["#{@single_swim} FINS free"]) ==
        [%{type: "interval", endConditionValue: 800, stroke: "free", element: "FINS"}]
    end

    test "should create list with repeat info" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse([@single_swim_repeat]) == [
        %{type: "repeat", numberOfIterations: 15, steps: [
          %{type: "interval", endConditionValue: 100}, %{type: "rest", endCondition: "fixed", endConditionValue: 20}
        ]}]
    end

    test "should create list with double repeat info" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse([@double_swim_repeat]) == [
        %{type: "repeat", numberOfIterations: 15, steps: [
          %{type: "interval", endConditionValue: 100}, %{type: "rest", endCondition: "fixed", endConditionValue: 20},
          %{type: "interval", endConditionValue: 75}, %{type: "rest", endCondition: "fixed", endConditionValue: 20}
        ]}]
    end

    test "should create list with double repeat info along with elements and descrition details" do
      assert GarminWorkoutBuilder.SwimWorkoutParser.parse(["#{@double_swim_repeat} #{@swim_elements} #{@swim_step_description}"]) == [
        %{type: "repeat", numberOfIterations: 15, steps: [
          %{type: "interval", endConditionValue: 100, description: "prog", element: "MP"}, %{type: "rest", endCondition: "fixed", endConditionValue: 20},
          %{type: "interval", endConditionValue: 75, description: "prog", element: "MP"}, %{type: "rest", endCondition: "fixed", endConditionValue: 20}
        ]}]
    end
  end

  describe "metadata?" do
    test "should be false for empty" do
      refute " " |> GarminWorkoutBuilder.SwimWorkoutParser.metadata?
    end

    test "should be false for misspelled input" do
      refute "T1T3S4D1" |> GarminWorkoutBuilder.SwimWorkoutParser.metadata?
    end

    test "should be false for wrong day number" do
      refute "T3P2S1D8" |> GarminWorkoutBuilder.SwimWorkoutParser.metadata?
    end

    test "should be true for proper workout name" do
      assert @metadata |> GarminWorkoutBuilder.SwimWorkoutParser.metadata?
    end

    test "should be true for discipline specific name ('a', 'b', 'r')" do
      assert @metadata <> "a" |> GarminWorkoutBuilder.SwimWorkoutParser.metadata?
    end
  end

  describe "swim_warmup?" do
    test "should be false for empty" do
      refute " " |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup?
    end

    test "should be false for misspelled input" do
      refute "400 ec" |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup?
    end

    test "should be false for messy input" do
      refute "400 e c" |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup?
    end

    test "should be true for swim warmup" do
      assert @swim_warmup |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup?
    end
  end

  describe "swim_repeat?" do
    test "should be false for empty" do
      refute " " |> GarminWorkoutBuilder.SwimWorkoutParser.swim_repeat?
    end

    test "should be false for warmup" do
      refute @swim_warmup |> GarminWorkoutBuilder.SwimWorkoutParser.swim_repeat?
    end

    test "should be false for swim elements" do
      refute @swim_elements |> GarminWorkoutBuilder.SwimWorkoutParser.swim_repeat?
    end

    test "should be true for single swim repeat" do
      assert @single_swim_repeat |> GarminWorkoutBuilder.SwimWorkoutParser.swim_repeat?
    end

    test "should be true for single swim repeat with elements" do
      assert "#{@single_swim_repeat} #{@swim_elements}" |> GarminWorkoutBuilder.SwimWorkoutParser.swim_repeat?
    end

    test "should be true for double swim repeat" do
      assert @double_swim_repeat |> GarminWorkoutBuilder.SwimWorkoutParser.swim_repeat?
    end
  end
end
