class MealPlan::DayCard < BaseComponent
  needs day : MealWeek::Day
  needs editable : Bool

  def render
    section class: "card meal-day" do
      h2 French.weekday_date(day.day)
      canteens
      meal_slot "Déjeuner", Meals::Slot::Lunch, day.lunch, [] of String
      meal_slot "Dîner", Meals::Slot::Dinner, day.dinner, day.warnings
    end
  end

  private def canteens
    return if day.canteens.empty?
    ul class: "canteens" do
      day.canteens.each do |canteen|
        li do
          span "Cantine #{canteen.school.name} : ", class: "quest-state"
          if meal = canteen.meal
            text "#{meal.dish} (#{French.tag(meal.tag)})"
          else
            span "pas encore saisi", class: "empty"
          end
        end
      end
    end
  end

  private def meal_slot(label : String, slot : Meals::Slot, meal : HomeMeal?, warnings : Array(String))
    div class: "meal-slot" do
      div class: "quest-title" do
        strong label
        if meal
          text "#{meal.dish} (#{French.tag(meal.tag)})"
        else
          span "rien de prévu", class: "empty"
        end
      end
      warnings.each { |warning| para warning, class: "meal-warning" }
      edit_form(slot, meal) if editable?
    end
  end

  private def edit_form(slot : Meals::Slot, meal : HomeMeal?)
    key = slot.lunch? ? "dejeuner" : "diner"
    prefix = "meal_#{day.day.to_s("%F")}_#{key}"
    details class: "member-edit" do
      summary meal ? "Modifier" : "Prévoir", flow_id: "#{prefix}_open"
      form_for HomeMeals::Save.with(day.day.to_s("%F"), key) do
        label "Plat", for: "#{prefix}_dish"
        input type: "text", id: "#{prefix}_dish", name: "home_meal:dish", value: meal.try(&.dish).to_s,
          list: "known-dishes", autocomplete: "off", flow_id: "#{prefix}_dish"
        label "Type de plat", for: "#{prefix}_tag"
        select_tag(prefix, meal.try(&.tag))
        submit "Enregistrer", flow_id: "#{prefix}_save"
      end
    end
  end

  private def select_tag(prefix : String, current : Meals::MainTag?)
    select_tag_element(prefix) do
      Meals::MainTag.values.each do |tag|
        if tag == current
          option French.tag(tag), value: tag.to_s, selected: "selected"
        else
          option French.tag(tag), value: tag.to_s
        end
      end
    end
  end

  private def select_tag_element(prefix : String, &)
    tag "select", name: "home_meal:tag", id: "#{prefix}_tag", flow_id: "#{prefix}_tag" do
      yield
    end
  end
end
