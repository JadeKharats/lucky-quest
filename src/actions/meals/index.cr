class Meals::Index < BrowserAction
  include WeekParam

  param semaine : String = ""

  get "/repas" do
    html IndexPage, week: MealWeek.for(monday_of(semaine, Time.local(Household::TIME_ZONE)))
  end
end
