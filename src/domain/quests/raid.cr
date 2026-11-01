module Quests
  # How a raid step is done. Stored values never change.
  enum StepRule
    # "Chacun sa part": every participant checks her own part.
    Everyone = 0
    # "Un seul suffit": the first participant who checks does it.
    Anyone = 1
  end

  record RaidStep, id : Int64, title : String, participant_ids : Array(Int64), rule : StepRule

  # A family quest in ordered steps; it recurs like a quest.
  record Raid, id : Int64, title : String, recurrence : Recurrence, steps : Array(RaidStep)

  # "C'est fait !" of one member on one step, in the current period.
  record RaidCheck, step_id : Int64, member_id : Int64
end
