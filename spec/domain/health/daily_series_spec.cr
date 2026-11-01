require "../spec_helper"

describe Health::DailySeries do
  it "has no days without weighings" do
    Health::DailySeries.new(Array(Health::Weighing).new, PARIS).days.should be_empty
  end

  it "keeps one value per calendar day, oldest first" do
    series = Health::DailySeries.new([
      weighing(72.0, at: paris(2026, 11, 2)),
      weighing(73.0, at: paris(2026, 11, 1)),
    ], PARIS)

    series.days.map(&.date).should eq([paris(2026, 11, 1, 0), paris(2026, 11, 2, 0)])
    series.days.map(&.kilograms).should eq([73.0, 72.0])
  end

  it "averages the weighings of the same day" do
    series = Health::DailySeries.new([
      weighing(72.0, at: paris(2026, 11, 1, 7)),
      weighing(72.6, at: paris(2026, 11, 1, 22)),
    ], PARIS)

    series.days.size.should eq(1)
    series.days.first.kilograms.should be_close(72.3, 0.001)
  end

  it "cuts days at midnight in the given time zone, not in UTC" do
    # 00:30 in Paris is still the previous day in UTC.
    series = Health::DailySeries.new([
      weighing(72.0, at: paris(2026, 11, 1, 23, 30)),
      weighing(74.0, at: paris(2026, 11, 2, 0, 30)),
    ], PARIS)

    series.days.map(&.kilograms).should eq([72.0, 74.0])
  end
end
