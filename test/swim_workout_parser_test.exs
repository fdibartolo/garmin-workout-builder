defmodule GarminWorkoutBuilder.SwimWorkoutParserTest do
  use ExUnit.Case

  @swim_warmup "400 e/c"
  @swim_elements "MP snorkel"
  @single_swim_repeat "15x(100 [20''])"
  @double_swim_repeat "15x(100 75 [20''])"

  describe "single_swim_repeat?" do
    test "should be false for empty" do
      assert " " |> GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :false
    end

    test "should be false for warmup" do
      assert @swim_warmup |> GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :false
    end

    test "should be false for swim elements" do
      assert @swim_elements |> GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :false
    end

    test "should be true for single swim repeat" do
      assert @single_swim_repeat |> GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :true
    end

    test "should be true for single swim repeat with elements" do
      assert "#{@single_swim_repeat} #{@swim_elements}" |> GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :true
    end

    test "should be false for double swim repeat" do
      assert @double_swim_repeat |> GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :false
    end
  end
end
