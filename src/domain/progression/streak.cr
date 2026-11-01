module Progression
  # Days in a row on which the member did at least one quest that was due.
  # Days with nothing due neither count nor break it, and today only counts
  # once something is done. Days are the first instant of each day.
  class Streak
    def initialize(@due : Array(Time), @done : Array(Time), @today : Time)
    end

    def length : Int32
      day = @today.at_beginning_of_day
      count = 0
      count += 1 if @done.includes?(day)
      while (day = day.shift(days: -1)) >= earliest_due
        next unless @due.includes?(day)
        break unless @done.includes?(day)
        count += 1
      end
      count
    end

    private def earliest_due : Time
      @due.min? || @today.at_beginning_of_day
    end
  end
end
