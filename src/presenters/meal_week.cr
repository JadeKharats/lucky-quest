# The week's meals: each school's canteen lunch, the home plan, and the
# conflicts of each dinner with the daughters' canteen lunches.
class MealWeek
  record Canteen, school : School, meal : CanteenMeal?
  record Day, day : Time, canteens : Array(Canteen), lunch : HomeMeal?, dinner : HomeMeal?, warnings : Array(String)

  getter monday : Time
  getter days : Array(Day)
  getter suggestions : Array(String)

  def self.for(monday : Time) : self
    new(monday)
  end

  def initialize(@monday : Time)
    schools = SchoolQuery.ordered.to_a
    # The day after the week too: Sunday's dinner meets Monday's lunch.
    canteen = CanteenMealQuery.between(monday, monday.shift(days: 8)).to_a
    home = HomeMealQuery.between(monday, monday.shift(days: 7)).to_a
    pupils = UserQuery.household.to_a.select { |member| member.role.child? && member.school_id }
    rule = Meals::ConflictRule.new(lunches(pupils, canteen))
    names = pupils.to_h { |pupil| {pupil.id, pupil.name} }

    @days = (0..6).map do |offset|
      day = monday.shift(days: offset)
      dinner = home.find { |meal| meal.day == day && meal.slot.dinner? }
      warnings = dinner ? rule.conflicts(dinner.to_domain).map { |found| reason(found, names) } : [] of String
      Day.new(day, canteens(schools, canteen, day), home.find { |meal| meal.day == day && meal.slot.lunch? }, dinner, warnings)
    end
    @suggestions = HomeMealQuery.known_dishes
  end

  private def lunches(pupils : Array(User), canteen : Array(CanteenMeal)) : Array(Meals::CanteenLunch)
    pupils.flat_map do |pupil|
      canteen.select { |meal| meal.school_id == pupil.school_id }.map do |meal|
        Meals::CanteenLunch.new(child_id: pupil.id, day: meal.day, dish: meal.to_dish)
      end
    end
  end

  private def canteens(schools : Array(School), canteen : Array(CanteenMeal), day : Time) : Array(Canteen)
    schools.select(&.days.includes?(day.day_of_week)).map do |school|
      Canteen.new(school, canteen.find { |meal| meal.school_id == school.id && meal.day == day })
    end
  end

  # "⛔ Lasagnes à la cantine de Lina ce midi"
  private def reason(conflict : Meals::Conflict, names : Hash(Int64, String)) : String
    icon = conflict.severity.blocking? ? "⛔" : "⚠️"
    moment = conflict.same_day ? "ce midi" : "demain midi"
    "#{icon} #{conflict.lunch.dish.name} à la cantine de #{names[conflict.lunch.child_id]} #{moment}"
  end
end
