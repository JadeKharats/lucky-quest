module Progression
  THRESHOLDS = [0, 150, 500, 1200, 2500, 5000]

  # From the lifetime XP earned: spending never lowers it.
  enum Rank
    E
    D
    C
    B
    A
    S

    def self.for(xp : Int) : self
      values.reverse!.find! { |rank| xp >= rank.threshold }
    end

    def threshold : Int32
      THRESHOLDS[value]
    end

    def next_rank : self?
      self.class.from_value?(value + 1)
    end
  end

  record Standing, xp : Int32 do
    def rank : Rank
      Rank.for(xp)
    end

    def next_rank : Rank?
      rank.next_rank
    end

    def xp_to_next : Int32
      next_rank.try { |higher| higher.threshold - xp } || 0
    end

    # How far into the current rank, 0.0 to 1.0, two decimals.
    def progress : Float64
      up = next_rank
      return 1.0 unless up
      ((xp - rank.threshold) / (up.threshold - rank.threshold)).round(2)
    end
  end
end
