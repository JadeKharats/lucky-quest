# Home: what the member attends or drives today and tomorrow, and the trips
# nobody drives yet this week (for parents and grandparents).
class AgendaPlan::Upcoming < BaseComponent
  needs upcoming : Array(Agenda::Occurrence)
  needs open_trips : Array(Agenda::Trip)
  needs names : Hash(Int64, String)

  def render
    return if upcoming.empty? && open_trips.empty?

    section class: "card quests" do
      h2 "Agenda"
      ul do
        upcoming.each do |occurrence|
          activity = occurrence.activity
          li "#{French.weekday_date(occurrence.day)} #{SaveActivity.clock(activity.start_minutes)} · #{activity.title}"
        end
        open_trips.each do |trip|
          li class: "meal-warning" do
            text "⚠️ Qui conduit ? #{trip.occurrence.activity.title} (#{trip.leg.to? ? "aller" : "retour"}), #{French.weekday_date(trip.occurrence.day)}"
          end
        end
      end
      link "Voir l'agenda →", to: Schedules::Index
    end
  end
end
