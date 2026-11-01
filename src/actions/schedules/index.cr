class Schedules::Index < BrowserAction
  include WeekParam

  param semaine : String = ""

  get "/agenda" do
    monday = monday_of(semaine, Time.local(Household::TIME_ZONE))
    occurrences = AgendaBoard.schedule.between(monday, monday.shift(days: 7))
    html IndexPage, monday: monday, occurrences: occurrences, names: AgendaBoard.names,
      household: UserQuery.household.to_a, activities: ActivityQuery.ordered.to_a
  end
end
