class Schedules::IndexPage < MainLayout
  needs monday : Time
  needs occurrences : Array(Agenda::Occurrence)
  needs names : Hash(Int64, String)
  needs household : Array(User)
  needs activities : Array(Activity)

  def page_title
    "Agenda"
  end

  def content
    h1 "Agenda"
    navigation
    days = (0..6).map { |offset| monday.shift(days: offset) }
    if occurrences.empty?
      section(class: "card") { para "Aucune activité cette semaine.", class: "empty" }
    end
    days.each do |day|
      todays = occurrences.select { |occurrence| occurrence.day == day }
      next if todays.empty?
      mount AgendaPlan::DayCard, day: day, occurrences: todays, member: current_user, names: names,
        drivers: household.select(&.role.drive?)
    end
    feed_section
    mount AgendaPlan::Activities, activities: activities, household: household if current_user.role.manage_family?
  end

  private def navigation
    div class: "week-nav" do
      link "← Semaine précédente", to: Schedules::Index.with(semaine: monday.shift(days: -7).to_s("%F"))
      strong "Semaine du #{French.date(monday)}"
      link "Semaine suivante →", to: Schedules::Index.with(semaine: monday.shift(days: 7).to_s("%F"))
    end
  end

  private def feed_section
    section class: "card" do
      h2 "Mon calendrier"
      para "Ajoute tes activités et tes trajets au calendrier de ton téléphone avec un lien secret.", class: "quest-state"
      form_for CalendarFeeds::Create do
        submit current_user.calendar_token_digest ? "Nouveau lien (l'ancien ne marchera plus)" : "Créer mon lien", flow_id: "calendar-link"
      end
    end
  end
end
