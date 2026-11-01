module Meals
  enum Slot
    Lunch  = 0
    Dinner = 1
  end

  enum Severity
    Warning
    Blocking
  end

  record CanteenLunch, child_id : Int64, day : Time, dish : Dish
  record HomeMeal, day : Time, slot : Slot, dish : Dish

  # `same_day`: the canteen lunch is the same day as the dinner (else it is
  # the next day's lunch).
  record Conflict, severity : Severity, lunch : CanteenLunch, same_day : Bool

  # Checked per daughter against her school's lunch: the dinner the same day
  # and the dinner the evening before. Home lunches on canteen days are not
  # checked (she is at school). Warnings only: the parent decides.
  class ConflictRule
    def initialize(@lunches : Array(CanteenLunch))
    end

    def conflicts(meal : HomeMeal) : Array(Conflict)
      return [] of Conflict unless meal.slot.dinner?
      @lunches.compact_map { |lunch| conflict(meal, lunch) }.sort_by! { |found| -found.severity.value }
    end

    def worst(meal : HomeMeal) : Conflict?
      conflicts(meal).first?
    end

    private def conflict(meal : HomeMeal, lunch : CanteenLunch) : Conflict?
      same_day = lunch.day == meal.day
      return unless same_day || lunch.day == meal.day.shift(days: 1)

      same_dish = lunch.dish.same_dish?(meal.dish)
      return unless same_dish || same_tag?(lunch.dish, meal.dish)

      severity = same_day && same_dish ? Severity::Blocking : Severity::Warning
      Conflict.new(severity: severity, lunch: lunch, same_day: same_day)
    end

    # "Autre" says nothing about the dish: it never matches by tag.
    private def same_tag?(canteen : Dish, home : Dish) : Bool
      !canteen.tag.other? && canteen.tag == home.tag
    end
  end
end
