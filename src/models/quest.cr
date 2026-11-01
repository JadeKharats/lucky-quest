# A recurring quest of one member. Occurrences are computed by the domain;
# only completions are stored.
class Quest < BaseModel
  table do
    belongs_to user : User
    column title : String
    column frequency : Quests::Frequency
    # Chosen days, bit 0 = Monday … bit 6 = Sunday (Weekdays only).
    column days_mask : Int32 = 0
    column archived_at : Time?
    column xp : Int32 = 10
    # Done by itself when its daughter has entered next week's canteen menu.
    column canteen_menu : Bool = false
  end

  def recurrence : Quests::Recurrence
    Quests::Recurrence.load(frequency, days_mask)
  end

  def to_domain : Quests::Quest
    Quests::Quest.new(id: id, title: title, recurrence: recurrence)
  end
end
