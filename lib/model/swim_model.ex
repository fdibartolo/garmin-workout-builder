defmodule GarminWorkoutBuilder.SwimModel.SportType do
  defstruct [sportTypeId: 4, sportTypeKey: "swimming"]
end

defmodule GarminWorkoutBuilder.SwimModel.PoolLengthUnit do
  defstruct [unitKey: "meter"]
end

defmodule GarminWorkoutBuilder.SwimModel.EstimatedDistanceUnit do
  defstruct [:unitId, :unitKey, :factor]
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
    estimatedDistanceUnit: %GarminWorkoutBuilder.SwimModel.EstimatedDistanceUnit{}
  ]
end
