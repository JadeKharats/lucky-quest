module Quests
  record Quest, id : Int64, title : String, recurrence : Recurrence

  # A stored "C'est fait !" for one occurrence of a quest.
  record Completion, quest_id : Int64, period_start : Time, validated : Bool
end
