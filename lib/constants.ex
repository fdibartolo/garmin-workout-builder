defmodule GarminWorkoutBuilder.Constants do

  # def single_swim_repeat_regex, do: ~r/\d+x\(\d+\s\[\d+''\]\)/

  def constants do
    %{
      :swim_warmup_regex => ~r<\d+ e/c>,
      :single_swim_repeat_regex => ~r/\d+x\(\d+\s\[\d+''\]\)/
    }
  end
end
