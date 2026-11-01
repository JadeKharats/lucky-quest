# "C'est fait !" of one member on one raid step, for one period.
class RaidCheck < BaseModel
  table do
    belongs_to raid_step : RaidStep
    belongs_to user : User
    column period_start : Time
    column checked_at : Time
  end
end
