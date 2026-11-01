class Meals::IndexPage < MainLayout
  needs week : MealWeek

  def page_title
    "Repas"
  end

  def content
    h1 "Repas"
    canteen_shortcut if current_user.role.enter_canteen_menu?
    navigation
    datalist id: "known-dishes" do
      week.suggestions.each { |name| option value: name }
    end
    week.days.each do |day|
      mount MealPlan::DayCard, day: day, editable: current_user.role.plan_meals?
    end
  end

  private def canteen_shortcut
    section class: "card shortcut" do
      link "Noter le menu de ma cantine →", to: Canteen::Index, flow_id: "canteen-shortcut"
    end
  end

  private def navigation
    monday = week.monday
    div class: "week-nav" do
      link "← Semaine précédente", to: Meals::Index.with(semaine: monday.shift(days: -7).to_s("%F"))
      strong "Semaine du #{French.date(monday)}"
      link "Semaine suivante →", to: Meals::Index.with(semaine: monday.shift(days: 7).to_s("%F"))
    end
  end
end
