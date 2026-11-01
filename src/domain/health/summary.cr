module Health
  # Everything the weight page shows, computed from the owner's weighings.
  class Summary
    getter latest : Weighing?

    def initialize(weighings : Array(Weighing), today : Time, location : Time::Location)
      @today = today.in(location)
      @latest = weighings.max_by?(&.measured_at)
      @series = DailySeries.new(weighings, location)
      @moving_average = MovingAverage.new(@series)
    end

    def average : Float64?
      @moving_average.at(@today)
    end

    def trend : Trend?
      Trend.over_a_week(@moving_average, @today)
    end

    def daily : Array(DailyWeight)
      @series.days
    end

    def averages : Array(DailyWeight)
      @moving_average.points
    end
  end
end
