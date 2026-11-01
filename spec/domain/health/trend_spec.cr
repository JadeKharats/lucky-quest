require "../spec_helper"

private def trend_between(before : Float64, now : Float64) : Health::Trend?
  series = Health::DailySeries.new([
    weighing(before, at: paris(2026, 11, 1)),
    weighing(now, at: paris(2026, 11, 8)),
  ], PARIS)
  # On the 8th the window (2nd–8th) holds only `now`; on the 1st only `before`.
  Health::Trend.over_a_week(Health::MovingAverage.new(series), today: paris(2026, 11, 8))
end

describe Health::Trend do
  it "goes down when the average lost at least 0.2 kg in a week" do
    trend = trend_between(72.4, 72.2)

    trend.try(&.direction).should eq(Health::Trend::Direction::Down)
    trend.try(&.delta).should eq(-0.2)
  end

  it "goes up when the average gained at least 0.2 kg in a week" do
    trend_between(72.0, 72.2).try(&.direction).should eq(Health::Trend::Direction::Up)
  end

  it "is stable below 0.2 kg either way" do
    trend_between(72.0, 72.1).try(&.direction).should eq(Health::Trend::Direction::Stable)
    trend_between(72.1, 72.0).try(&.direction).should eq(Health::Trend::Direction::Stable)
    trend_between(72.0, 72.0).try(&.direction).should eq(Health::Trend::Direction::Stable)
  end

  it "rounds the delta to grams so float noise does not cross the threshold" do
    # 71.8 - 72.0 is -0.20000000000000284 in floating point.
    trend_between(72.0, 71.8).try(&.delta).should eq(-0.2)
    trend_between(71.0, 72.0).try(&.delta).should eq(1.0)
  end

  it "is unknown without an average a week ago" do
    series = Health::DailySeries.new([weighing(72.0, at: paris(2026, 11, 8))], PARIS)

    Health::Trend.over_a_week(Health::MovingAverage.new(series), today: paris(2026, 11, 8)).should be_nil
  end

  it "is unknown without an average today" do
    series = Health::DailySeries.new([weighing(72.0, at: paris(2026, 10, 30))], PARIS)

    Health::Trend.over_a_week(Health::MovingAverage.new(series), today: paris(2026, 11, 8)).should be_nil
  end
end
