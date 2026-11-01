# A family quest in ordered steps ("Le Sol"). Its progress is computed by
# the domain from the period's checks.
class Raid < BaseModel
  table do
    column title : String
    column frequency : Quests::Frequency
    column days_mask : Int32 = 0
    column archived_at : Time?
    column xp : Int32 = 30
  end

  def recurrence : Quests::Recurrence
    Quests::Recurrence.load(frequency, days_mask)
  end
end
