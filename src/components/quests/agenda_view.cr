class Quests::AgendaView < BaseComponent
  needs agenda : Quests::Agenda

  def render
    if agenda.today.empty? && agenda.this_week.empty?
      section class: "card" do
        para "Aucune quête pour l'instant.", class: "empty"
      end
    else
      list "Aujourd'hui", agenda.today
      list "Cette semaine", agenda.this_week
    end
  end

  private def list(heading : String, occurrences : Array(Quests::Occurrence))
    return if occurrences.empty?

    section class: "card quests" do
      h2 heading
      ul do
        occurrences.each { |occurrence| mount Quests::OccurrenceRow, occurrence: occurrence }
      end
    end
  end
end
