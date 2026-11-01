class Canteen::IndexPage < MainLayout
  needs school : School?
  needs week : Meals::CanteenWeek?
  needs monday : Time
  needs meals : Array(CanteenMeal)

  def page_title
    "Cantine"
  end

  def content
    h1 "Cantine"
    school_week = week
    if (current = school) && school_week
      menu_form(current, school_week)
    else
      section class: "card" do
        para "Demande à un parent de choisir ton école sur la page Famille.", class: "empty"
      end
    end
  end

  private def menu_form(current : School, school_week : Meals::CanteenWeek)
    div class: "week-nav" do
      link "← Semaine précédente", to: Canteen::Index.with(semaine: monday.shift(days: -7).to_s("%F"))
      strong "#{current.name} · semaine du #{French.date(monday)}"
      link "Semaine suivante →", to: Canteen::Index.with(semaine: monday.shift(days: 7).to_s("%F"))
    end
    section class: "card" do
      form_for Canteen::Save.with(monday.to_s("%F")) do
        school_week.days.each { |day| day_fields(day) }
        submit "Enregistrer le menu", flow_id: "save-canteen"
      end
    end
  end

  private def day_fields(day : Time)
    meal = meals.find { |candidate| candidate.day == day }
    prefix = "canteen_#{day.to_s("%F")}"
    fieldset class: "canteen-day" do
      legend French.weekday_date(day)
      label "Plat principal", for: "#{prefix}_dish"
      input type: "text", id: "#{prefix}_dish", name: "canteen_week:dishes[]", value: meal.try(&.dish).to_s,
        autocomplete: "off", flow_id: "#{prefix}_dish"
      label "Type de plat", for: "#{prefix}_tag"
      tag "select", name: "canteen_week:tags[]", id: "#{prefix}_tag", flow_id: "#{prefix}_tag" do
        Meals::MainTag.values.each do |main_tag|
          if main_tag == meal.try(&.tag)
            option French.tag(main_tag), value: main_tag.to_s, selected: "selected"
          else
            option French.tag(main_tag), value: main_tag.to_s
          end
        end
      end
    end
  end
end
