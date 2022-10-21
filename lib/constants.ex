defmodule GarminWorkoutBuilder.Constants do

  # def single_swim_repeat_regex, do: ~r/\d+x\(\d+\s\[\d+''\]\)/

  def constants do
    %{
      :single_swim_repeat_regex => ~r/\d+x\(\d+\s\[\d+''\]\)/
    }
  end
end
