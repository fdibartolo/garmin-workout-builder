defmodule GarminWorkoutBuilder.Constants do

  # def single_swim_repeat_regex, do: ~r/\d+x\(\d+\s\[\d+''\]\)/

  def constants do
    %{
      :swim_warmup_regex => ~r<\d+ e/c>,
      :single_swim_repeat_regex => ~r/\d+x\(\d+\s\[\d+''\]\)/,
      :swim_step_type_warmup_id => 1,
      :swim_step_type_warmup_key => "warmup",
      :swim_step_type_cooldown_id => 2,
      :swim_step_type_cooldown_key => "cooldown",
      :swim_step_type_interval_id => 3,
      :swim_step_type_interval_key => "interval",
      :swim_condition_lap_button_id => 1,
      :swim_condition_lap_button_key => "lap.button",
      :swim_condition_fixed_rest_id => 8,
      :swim_condition_fixed_rest_key => "fixed.rest",
      :swim_stroke_type_any_id => 1,
      :swim_stroke_type_any_key => "any_stroke",
      :swim_stroke_type_drill_id => 4,
      :swim_stroke_type_drill_key => "drill",
      :swim_stroke_type_free_id => 6,
      :swim_stroke_type_free_key => "free",
      :swim_equipment_type_paddles_id => 3,
      :swim_equipment_type_paddles_key => "paddles",
    }
  end
end
