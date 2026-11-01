module Health
  # Smooths the daily noise (water, meals): the mean of the daily weights of
  # a day and the six calendar days before it. Days without a weighing are
  # left out rather than counted as zero.
  class MovingAverage
    WINDOW_DAYS = 7

    def initialize(@series : DailySeries)
    end

    # The average for the calendar day of `day` (in `day`'s time zone).
    def at(day : Time) : Float64?
      last = day.at_beginning_of_day
      first = last.shift(days: 1 - WINDOW_DAYS)
      in_window = @series.days.select { |daily| first <= daily.date <= last }
      return if in_window.empty?

      in_window.sum(&.kilograms) / in_window.size
    end

    # One averaged point per day of the series, for the curve.
    def points : Array(DailyWeight)
      @series.days.compact_map do |daily|
        at(daily.date).try { |kilograms| DailyWeight.new(daily.date, kilograms) }
      end
    end
  end
end
