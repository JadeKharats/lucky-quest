class Quests::AgendaView < BaseComponent
  needs agenda : Quests::Agenda
  needs words : Lexicon
  needs rewards : Hash(Int64, Int32) = {} of Int64 => Int32

  def render
    if agenda.today.empty? && agenda.this_week.empty?
      section class: "card" do
        para words.no_quests, class: "empty"
      end
    else
      list words.today, agenda.today, "today"
      list words.this_week, agenda.this_week, "week"
    end
  end

  private def list(heading : String, occurrences : Array(Quests::Occurrence), key : String)
    return if occurrences.empty?

    section class: "quests", id: "quests-#{key}" do
      div class: "section-head" do
        h2 heading
        span "#{occurrences.count { |occurrence| !occurrence.status.to_do? }} / #{occurrences.size}", class: "section-count"
      end
      ul class: "quest-cards" do
        occurrences.each_with_index do |occurrence, index|
          mount Quests::OccurrenceRow, occurrence: occurrence, words: words,
            reward: rewards[occurrence.quest.id]?, tint: index % Quests::OccurrenceRow::TINTS
        end
      end
    end
  end
end
