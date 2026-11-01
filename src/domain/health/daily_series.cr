module Health
  # The weight of a calendar day: the mean of that day's weighings.
  # `date` is midnight, local to the series' time zone.
  record DailyWeight, date : Time, kilograms : Float64

  # Weighings grouped by calendar day in a time zone, oldest day first.
  class DailySeries
    getter days : Array(DailyWeight)

    def initialize(weighings : Enumerable(Weighing), location : Time::Location)
      @days = weighings
        .group_by(&.measured_at.in(location).at_beginning_of_day)
        .map { |date, of_the_day| DailyWeight.new(date, mean(of_the_day)) }
        .sort_by!(&.date)
    end

    private def mean(weighings : Array(Weighing)) : Float64
      weighings.sum(&.kilograms.value) / weighings.size
    end
  end
end
