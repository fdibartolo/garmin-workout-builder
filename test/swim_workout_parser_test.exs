defmodule GarminWorkoutBuilder.SwimWorkoutParserTest do
  use ExUnit.Case

  @metadata "T3P2S1D7"
  @swim_warmup "400 e/c"
  @swim_elements "MP snorkel"
  @single_swim_repeat "15x(100 [20''])"
  @double_swim_repeat "15x(100 75 [20''])"

  describe "metadata?" do
    test "should be false for empty" do
      assert " " |> GarminWorkoutBuilder.SwimWorkoutParser.metadata? == :false
    end

    test "should be false for misspelled input" do
      assert "T1T3S4D1" |> GarminWorkoutBuilder.SwimWorkoutParser.metadata? == :false
    end

    test "should be false for wrong day number" do
      assert "T3P2S1D8" |> GarminWorkoutBuilder.SwimWorkoutParser.metadata? == :false
    end

    test "should be true for proper workout name" do
      assert @metadata |> GarminWorkoutBuilder.SwimWorkoutParser.metadata? == :true
    end

    test "should be true for discipline specific name ('a', 'b', 'r')" do
      assert @metadata <> "a" |> GarminWorkoutBuilder.SwimWorkoutParser.metadata? == :true
    end
  end

  describe "swim_warmup?" do
    test "should be false for empty" do
      assert " " |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup? == :false
    end

    test "should be false for misspelled input" do
      assert "400 ec" |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup? == :false
    end

    test "should be false for messy input" do
      assert "400 e c" |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup? == :false
    end

    test "should be true for swim warmup" do
      assert @swim_warmup |> GarminWorkoutBuilder.SwimWorkoutParser.swim_warmup? == :true
    end
  end

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
