require "../spec_helper"

private def summary_of(weighings, today = paris(2026, 11, 8, 20)) : Health::Summary
  Health::Summary.new(weighings, today: today, location: PARIS)
end

describe Health::Summary do
  it "is empty without weighings" do
    summary = summary_of(Array(Health::Weighing).new)

    summary.latest.should be_nil
    summary.average.should be_nil
    summary.trend.should be_nil
    summary.daily.should be_empty
    summary.averages.should be_empty
  end

  it "knows the latest weighing, whatever the input order" do
    latest = weighing(71.5, at: paris(2026, 11, 8, 7))
    summary = summary_of([latest, weighing(72.0, at: paris(2026, 11, 7))])

    summary.latest.should eq(latest)
  end

  it "gives today's moving average and the weekly trend" do
    summary = summary_of([
      weighing(73.0, at: paris(2026, 11, 1)),
      weighing(72.0, at: paris(2026, 11, 8)),
    ])

    summary.average.should eq(72.0)
    summary.trend.try(&.direction).should eq(Health::Trend::Direction::Down)
  end

  it "reads today in the summary's time zone" do
    # 23:30 UTC on the 7th is already the 8th in Paris.
    summary = summary_of(
      [weighing(72.0, at: paris(2026, 11, 8, 0, 15))],
      today: Time.utc(2026, 11, 7, 23, 30))

    summary.average.should eq(72.0)
  end

  it "exposes the daily weights and their moving averages for the curve" do
    summary = summary_of([
      weighing(72.0, at: paris(2026, 11, 7)),
      weighing(74.0, at: paris(2026, 11, 8)),
    ])

    summary.daily.map(&.kilograms).should eq([72.0, 74.0])
    summary.averages.map(&.kilograms).should eq([72.0, 73.0])
  end
end
