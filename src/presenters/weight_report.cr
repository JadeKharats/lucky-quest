# What the weight page needs for one owner: the summary (latest, average,
# trend, curve) and the most recent weighings.
class WeightReport
  CURVE_DAYS = 90
  RECENT     = 10

  getter summary : Health::Summary
  getter recent : Array(Weighing)
  getter curve_from : Time

  def curve_to : Time
    curve_from.shift(days: CURVE_DAYS)
  end

  def initialize(@summary, @recent, @curve_from)
  end

  def self.for(owner : User, now : Time = Time.utc) : self
    today = now.in(Quest::TIME_ZONE).at_beginning_of_day
    curve_from = today.shift(days: -CURVE_DAYS)
    # A week more than the curve, so its first points have a full average.
    weighings = WeighingQuery.owned_by(owner)
      .since(curve_from.shift(days: -Health::MovingAverage::WINDOW_DAYS))
      .newest_first
      .to_a
    summary = Health::Summary.new(weighings.map(&.to_domain), today: now, location: Quest::TIME_ZONE)

    new(summary, weighings.first(RECENT), curve_from)
  end
end
