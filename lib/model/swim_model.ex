defmodule GarminWorkoutBuilder.SwimModel.SportType do
  defstruct [sportTypeId: 4, sportTypeKey: "swimming"]
end

defmodule GarminWorkoutBuilder.SwimModel.PoolLengthUnit do
  defstruct [unitKey: "meter"]
end

defmodule GarminWorkoutBuilder.SwimModel.EstimatedDistanceUnit do
  defstruct [:unitId, :unitKey, :factor]
end

defmodule GarminWorkoutBuilder.SwimModel.RegularStepType do
  defstruct [:stepTypeId, :stepTypeKey]
end

defmodule GarminWorkoutBuilder.SwimModel.RestStepType do
  defstruct [stepTypeId: 5, stepTypeKey: "rest"]
end

defmodule GarminWorkoutBuilder.SwimModel.RepeatStepType do
  defstruct [stepTypeId: 6, stepTypeKey: "repeat"]
end

defmodule GarminWorkoutBuilder.SwimModel.RegularEndCondition do
  defstruct [conditionTypeId: 3, conditionTypeKey: "distance"]
end

defmodule GarminWorkoutBuilder.SwimModel.RestEndCondition do
  defstruct [:conditionTypeId, :conditionTypeKey] # lap button or fixed rest time
end

defmodule GarminWorkoutBuilder.SwimModel.RepeatEndCondition do
  defstruct [conditionTypeId: 7, conditionTypeKey: "iterations"]
end

defmodule GarminWorkoutBuilder.SwimModel.PreferredEndConditionUnit do
  defstruct [unitKey: "meter"] # null for rest steps
end

defmodule GarminWorkoutBuilder.SwimModel.StrokeType do
  defstruct [:strokeTypeId, :strokeTypeKey]
end

defmodule GarminWorkoutBuilder.SwimModel.EquipmentType do
  defstruct [:equipmentTypeId, :equipmentTypeKey]
end

defmodule GarminWorkoutBuilder.SwimModel.RegularWorkoutStep do
  defstruct [
    :stepId,
    :childStepId,
    :stepOrder,
    :description,
    :endConditionValue,
    :endConditionCompare,
    :endConditionZone,
    :exerciseName,
    type: "ExecutableStepDTO",
    stepType: %GarminWorkoutBuilder.SwimModel.RegularStepType{},
    endCondition: %GarminWorkoutBuilder.SwimModel.RegularEndCondition{},
    preferredEndConditionUnit: %GarminWorkoutBuilder.SwimModel.PreferredEndConditionUnit{},
    strokeType: %GarminWorkoutBuilder.SwimModel.StrokeType{},
    equipmentType: %GarminWorkoutBuilder.SwimModel.EquipmentType{}
  ]
end

defmodule GarminWorkoutBuilder.SwimModel.RestWorkoutStep do
  defstruct [
    :stepId,
    :childStepId,
    :stepOrder,
    :preferredEndConditionUnit,
    :endConditionValue,
    :endConditionCompare,
    :endConditionZone,
    :exerciseName,
    type: "ExecutableStepDTO",
    stepType: %GarminWorkoutBuilder.SwimModel.RestStepType{},
    endCondition: %GarminWorkoutBuilder.SwimModel.RestEndCondition{}
  ]
end

defmodule GarminWorkoutBuilder.SwimModel.RepeatWorkoutStep do
  defstruct [
    :stepId,
    :childStepId,
    :stepOrder,
    :endConditionValue,
    :endConditionCompare,
    :endConditionZone,
    :exerciseName,
    :numberOfIterations,
    smartRepeat: false,
    type: "RepeatGroupDTO",
    workoutSteps: [], # could be regular step (warmup, cooldown, swim), rest or repeat step
    stepType: %GarminWorkoutBuilder.SwimModel.RepeatStepType{},
    endCondition: %GarminWorkoutBuilder.SwimModel.RepeatEndCondition{}
  ]
end

defmodule GarminWorkoutBuilder.SwimModel.WorkoutSegment do
  defstruct [
    segmentOrder: 1,
    sportType: %GarminWorkoutBuilder.SwimModel.SportType{},
    workoutSteps: [] # could be regular step (warmup, cooldown, swim), rest or repeat step
  ]
end

defmodule GarminWorkoutBuilder.SwimModel do
  defstruct [
    :workoutName,
    :subSportType,
    :avgTrainingSpeed,
    :estimateType,
    :estimatedDurationInSecs,
    :estimatedDistanceInMeters,
    poolLength: 25,
    poolLengthUnit: %GarminWorkoutBuilder.SwimModel.PoolLengthUnit{},
    sportType: %GarminWorkoutBuilder.SwimModel.SportType{},
    estimatedDistanceUnit: %GarminWorkoutBuilder.SwimModel.EstimatedDistanceUnit{},
    workoutSegments: [%GarminWorkoutBuilder.SwimModel.WorkoutSegment{}]
  ]
end
