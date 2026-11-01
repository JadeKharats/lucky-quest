# Title and recurrence of a raid, the same way as a quest's.
class SaveRaid < Raid::SaveOperation
  param_key :raid
  include QuestDetails

  permit_columns title, frequency, xp

  def self.form_for(raid : Raid) : self
    new(raid, days: raid.recurrence.days.map(&.value).to_a)
  end
end
