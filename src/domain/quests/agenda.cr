module Quests
  record Occurrence, quest : Quest, period_start : Time, status : Status

  # A member's quests on a given day: those due today, and the weekly ones of
  # this week, with what was already done. Missed occurrences of past days
  # simply are not there.
  class Agenda
    @occurrences : Array(Occurrence)

    def initialize(quests : Array(Quest), @completions : Array(Completion), @day : Time)
      @occurrences = quests
        .select(&.recurrence.due_on?(@day))
        .sort_by! { |quest| {quest.title, quest.id} }
        .map { |quest| occurrence(quest) }
    end

    def today : Array(Occurrence)
      @occurrences.reject(&.quest.recurrence.weekly?)
    end

    def this_week : Array(Occurrence)
      @occurrences.select(&.quest.recurrence.weekly?)
    end

    def occurrence_of(quest_id : Int64) : Occurrence?
      @occurrences.find { |occurrence| occurrence.quest.id == quest_id }
    end

    private def occurrence(quest : Quest) : Occurrence
      start = quest.recurrence.period_start(@day)
      completion = @completions.find { |done| done.quest_id == quest.id && done.period_start == start }
      Occurrence.new(quest: quest, period_start: start, status: Status.of(completion))
    end
  end
end
