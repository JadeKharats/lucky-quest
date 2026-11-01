module Quests
  # Stored values never change: they live in the database.
  enum Frequency
    Daily    = 0
    Weekdays = 1
    Weekly   = 2
  end

  # When a quest comes back: every day, on chosen days, or once a week
  # (any day from Monday to Sunday).
  struct Recurrence
    getter frequency : Frequency
    getter days : Set(Time::DayOfWeek)

    def self.daily : self
      new(Frequency::Daily, Set(Time::DayOfWeek).new)
    end

    def self.weekly : self
      new(Frequency::Weekly, Set(Time::DayOfWeek).new)
    end

    def self.on(days : Enumerable(Time::DayOfWeek)) : self
      raise ArgumentError.new("A quest on chosen days needs at least one day") if days.empty?
      new(Frequency::Weekdays, days.to_set)
    end

    # From the stored frequency and bit mask (bit 0 = Monday … bit 6 = Sunday).
    def self.load(frequency : Frequency, mask : Int32) : self
      case frequency
      in .daily?    then daily
      in .weekly?   then weekly
      in .weekdays? then on(Time::DayOfWeek.values.select { |day| mask.bit(day.value - 1) == 1 })
      end
    end

    private def initialize(@frequency, @days)
    end

    def mask : Int32
      days.sum { |day| 1 << (day.value - 1) }
    end

    def weekly? : Bool
      frequency.weekly?
    end

    def due_on?(day : Time) : Bool
      !frequency.weekdays? || days.includes?(day.day_of_week)
    end

    # The first day of the occurrence that `day` belongs to.
    def period_start(day : Time) : Time
      weekly? ? day.at_beginning_of_week : day.at_beginning_of_day
    end
  end
end
