module Family
  # When a member may still come in: until the end of a last day (inclusive,
  # in that day's time zone), or forever.
  struct AccessWindow
    getter ends_at : Time?

    def self.unlimited : self
      new(nil)
    end

    def self.through(last_day : Time) : self
      new(last_day.at_beginning_of_day.shift(days: 1))
    end

    def initialize(@ends_at : Time?)
    end

    def open?(now : Time) : Bool
      ends = ends_at
      ends.nil? || now < ends
    end

    def last_day : Time?
      ends_at.try(&.shift(days: -1))
    end
  end
end
