class AgendaPlan::DayCard < BaseComponent
  needs day : Time
  needs occurrences : Array(Agenda::Occurrence)
  needs member : User
  needs names : Hash(Int64, String)
  needs drivers : Array(User)

  LEGS = {Agenda::Leg::To => "aller", Agenda::Leg::Back => "retour"}

  def render
    section class: "card meal-day" do
      h2 French.weekday_date(day)
      occurrences.each { |occurrence| item(occurrence) }
    end
  end

  private def item(occurrence : Agenda::Occurrence)
    activity = occurrence.activity
    div class: "meal-slot #{occurrence.cancelled ? "cancelled" : ""}" do
      div class: "quest-title" do
        strong "#{SaveActivity.clock(activity.start_minutes)}–#{SaveActivity.clock(activity.end_minutes)} #{activity.title}"
        span [French.names(who(activity.participant_ids)), activity.place].reject(&.empty?).join(" · "), class: "quest-state"
      end
      if occurrence.cancelled
        para "Annulée", class: "meal-warning"
      else
        occurrence.trips.each { |trip| trip_line(occurrence, trip) }
      end
      parent_actions(occurrence) if member.role.manage_family?
    end
  end

  private def trip_line(occurrence : Agenda::Occurrence, trip : Agenda::Trip)
    leg = LEGS[trip.leg]
    driver = trip.driver_id.try { |id| names[id]? }
    div class: "trip" do
      text "#{leg.capitalize} : "
      if driver
        text driver
      else
        span "⚠️ Qui conduit ?", class: "meal-warning"
      end
      if member.role.drive?
        if trip.driver_id.nil?
          form_for Trips::Take.with(occurrence.activity.id, date(occurrence), leg), class: "inline" do
            submit "Je fais l'#{leg}", flow_id: "take-#{occurrence.activity.id}-#{date(occurrence)}-#{leg}"
          end
        elsif trip.driver_id == member.id
          form_for Trips::Release.with(occurrence.activity.id, date(occurrence), leg), class: "inline secondary" do
            submit "Je ne peux plus"
          end
        end
      end
    end
  end

  private def parent_actions(occurrence : Agenda::Occurrence)
    details class: "member-edit" do
      summary "Gérer"
      occurrence.trips.each do |trip|
        leg = LEGS[trip.leg]
        form_for Trips::Assign.with(occurrence.activity.id, date(occurrence), leg) do
          label "Conducteur #{leg}", for: "assign-#{occurrence.activity.id}-#{date(occurrence)}-#{leg}"
          tag "select", name: "trip:driver_id", id: "assign-#{occurrence.activity.id}-#{date(occurrence)}-#{leg}" do
            option "personne", value: ""
            drivers.each do |driver|
              if driver.id == trip.driver_id
                option driver.name, value: driver.id.to_s, selected: "selected"
              else
                option driver.name, value: driver.id.to_s
              end
            end
          end
          submit "Changer"
        end
      end
      if occurrence.cancelled
        form_for(Occurrences::Restore.with(occurrence.activity.id, date(occurrence)), class: "secondary") { submit "Rétablir" }
      else
        form_for(Occurrences::Cancel.with(occurrence.activity.id, date(occurrence)), class: "secondary") { submit "Annuler cette séance" }
      end
    end
  end

  private def who(ids : Array(Int64)) : Array(String)
    ids.compact_map { |id| names[id]? }
  end

  private def date(occurrence : Agenda::Occurrence) : String
    occurrence.day.to_s("%F")
  end
end
