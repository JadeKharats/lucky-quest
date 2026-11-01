# A daughter's school menu, next week by default.
class Canteen::Index < BrowserAction
  include Auth::RequireCanteenEditor
  include WeekParam

  param semaine : String = ""

  get "/cantine" do
    today = Time.local(Household::TIME_ZONE)
    monday = monday_of(semaine, today.at_beginning_of_week.shift(days: 7))
    school = current_user.school_id.try { |id| SchoolQuery.new.id(id).first? }
    meals = school ? CanteenMealQuery.between(monday, monday.shift(days: 7)).school_id(school.id).to_a : [] of CanteenMeal
    html IndexPage, school: school, week: school.try(&.week(monday)), monday: monday, meals: meals
  end
end
