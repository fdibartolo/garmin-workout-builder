defmodule GarminWorkoutBuilder.SwimWorkoutParserTest do
  use ExUnit.Case

  describe "swim series" do
    test "workout matches single swim repeat" do
      assert "15x(100 [20''])" |>
        GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :true
    end

    test "double swim repeat workout does not match single swim repeat" do
      assert "15x(100 75 [20''])" |>
        GarminWorkoutBuilder.SwimWorkoutParser.single_swim_repeat? == :false
    end

  end
end
