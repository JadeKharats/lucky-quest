# The member is chosen once; title and recurrence can change.
class UpdateQuest < Quest::SaveOperation
  param_key :quest
  include QuestDetails

  permit_columns title, frequency, xp, canteen_menu

  def self.form_for(quest : Quest) : self
    new(quest, days: quest.recurrence.days.map(&.value).to_a)
  end
end
