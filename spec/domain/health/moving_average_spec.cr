require "../spec_helper"

private def average_of(weighings : Array(Health::Weighing)) : Health::MovingAverage
  Health::MovingAverage.new(Health::DailySeries.new(weighings, PARIS))
end

describe Health::MovingAverage do
  it "is unknown when no day falls in the window" do
    average_of([weighing(72.0, at: paris(2026, 11, 1))]).at(paris(2026, 11, 8)).should be_nil
  end

  it "is the day's weight when it is the only day in the window" do
    average_of([weighing(72.0, at: paris(2026, 11, 1))]).at(paris(2026, 11, 1)).should eq(72.0)
  end

  it "spans the day and the six days before it" do
    average = average_of([
      weighing(80.0, at: paris(2026, 11, 1)), # 7 days before: outside
      weighing(72.0, at: paris(2026, 11, 2)), # 6 days before: inside
      weighing(74.0, at: paris(2026, 11, 8)),
    ])

    average.at(paris(2026, 11, 8)).should eq(73.0)
  end

  it "ignores the days after the given day" do
    average = average_of([
      weighing(72.0, at: paris(2026, 11, 1)),
      weighing(80.0, at: paris(2026, 11, 2)),
    ])

    average.at(paris(2026, 11, 1)).should eq(72.0)
  end

  it "averages only the days that have a weighing" do
    average = average_of([
      weighing(72.0, at: paris(2026, 11, 1)),
      weighing(73.0, at: paris(2026, 11, 4)),
    ])

    average.at(paris(2026, 11, 5)).should eq(72.5)
  end

  it "counts calendar days across a daylight saving change" do
    # Clocks went back on 2026-10-25: that week is 7 days but 169 hours.
    average = average_of([
      weighing(72.0, at: paris(2026, 10, 25, 0, 30)),
      weighing(74.0, at: paris(2026, 10, 31, 23, 30)),
    ])

    average.at(paris(2026, 10, 31, 23, 30)).should eq(73.0)
  end

  it "gives one point per day of the series" do
    average = average_of([
      weighing(72.0, at: paris(2026, 11, 1)),
      weighing(74.0, at: paris(2026, 11, 2)),
    ])

    average.points.map(&.date).should eq([paris(2026, 11, 1, 0), paris(2026, 11, 2, 0)])
    average.points.map(&.kilograms).should eq([72.0, 73.0])
  end
end
