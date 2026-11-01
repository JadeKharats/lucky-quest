module Health
  # Where the moving average went over the last week. Moves smaller than
  # 0.2 kg are noise: the trend stays stable.
  record Trend, delta : Float64 do
    enum Direction
      Down
      Stable
      Up
    end

    THRESHOLD = 0.2

    # nil until there is an average both today and a week ago.
    def self.over_a_week(average : MovingAverage, today : Time) : Trend?
      now = average.at(today)
      before = average.at(today.shift(days: -7))
      return unless now && before

      # Rounded to the gram so float noise cannot cross the threshold.
      new((now - before).round(3))
    end

    def direction : Direction
      if delta <= -THRESHOLD
        Direction::Down
      elsif delta >= THRESHOLD
        Direction::Up
      else
        Direction::Stable
      end
    end
  end
end
