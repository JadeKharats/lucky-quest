class RaidStepParticipant < BaseModel
  table do
    belongs_to raid_step : RaidStep
    belongs_to user : User
  end
end
