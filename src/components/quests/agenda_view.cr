class Quests::AgendaView < BaseComponent
  needs agenda : Quests::Agenda
  needs words : Lexicon

  def render
    if agenda.today.empty? && agenda.this_week.empty?
      section class: "card" do
        para words.no_quests, class: "empty"
      end
    else
      list words.today, agenda.today
      list words.this_week, agenda.this_week
    end
  end

  private def list(heading : String, occurrences : Array(Quests::Occurrence))
    return if occurrences.empty?

    section class: "card quests" do
      h2 heading
      ul do
        occurrences.each { |occurrence| mount Quests::OccurrenceRow, occurrence: occurrence, words: words }
      end
    end
  end
end
