module Meals
  # The days a school's canteen serves in one week (Monday to Sunday).
  class CanteenWeek
    getter monday : Time

    # From the stored mask: bit 0 = Monday … bit 6 = Sunday.
    def self.days_of(mask : Int32) : Array(Time::DayOfWeek)
      Time::DayOfWeek.values.select { |day| mask.bit(day.value - 1) == 1 }
    end

    def initialize(@days_of_week : Array(Time::DayOfWeek), day : Time)
      @monday = day.at_beginning_of_week
    end

    def days : Array(Time)
      (0..6).map { |offset| monday.shift(days: offset) }.select { |day| @days_of_week.includes?(day.day_of_week) }
    end

    def complete?(filled : Array(Time)) : Bool
      !days.empty? && days.all? { |day| filled.includes?(day) }
    end
  end
end
