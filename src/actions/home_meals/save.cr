class HomeMeals::Save < BrowserAction
  include Auth::RequireMealPlanner
  include WeekParam

  SLOTS = {"dejeuner" => Meals::Slot::Lunch, "diner" => Meals::Slot::Dinner}

  post "/repas/:date/:slot" do
    day = parse_day(date)
    chosen = SLOTS[slot]? || raise Lucky::RouteNotFoundError.new(context)
    SaveHomeMeal.run(params, day: day, slot: chosen) do |operation, saved|
      flash.failure = operation.errors.values.flatten.first? || "Repas non enregistré." unless saved
      redirect Meals::Index.with(semaine: day.at_beginning_of_week.to_s(DATE_FORMAT))
    end
  end
end
