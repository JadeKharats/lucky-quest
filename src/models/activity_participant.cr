class ActivityParticipant < BaseModel
  table do
    belongs_to activity : Activity
    belongs_to user : User
  end
end
