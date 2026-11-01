require "spec"
require "../../src/domain/health"
require "../../src/presenters/weight_chart"

private FROM = Time.utc(2026, 11, 1)
private TO   = Time.utc(2026, 11, 11)

private def chart(kilograms = [72.0, 74.0]) : WeightChart
  WeightChart.new(from: FROM, to: TO, kilograms: kilograms)
end

describe WeightChart do
  it "maps the time span onto the width, inside the padding" do
    chart.x(FROM).should eq(WeightChart::PADDING)
    chart.x(TO).should eq(WeightChart::WIDTH - WeightChart::PADDING)
    chart.x(Time.utc(2026, 11, 6)).should eq(WeightChart::WIDTH / 2)
  end

  it "maps weights onto the height, heavier higher, with half a kilo of margin" do
    chart.max_kilograms.should eq(74.5)
    chart.min_kilograms.should eq(71.5)
    chart.y(74.5).should eq(WeightChart::PADDING)
    chart.y(71.5).should eq(WeightChart::HEIGHT - WeightChart::PADDING)
    chart.y(73.0).should eq(WeightChart::HEIGHT / 2)
  end

  it "still has a height when every weight is the same" do
    flat = chart([72.0, 72.0])

    flat.y(72.0).should eq(WeightChart::HEIGHT / 2)
  end

  it "draws daily points as SVG polyline coordinates" do
    points = [
      Health::DailyWeight.new(FROM, 74.5),
      Health::DailyWeight.new(TO, 71.5),
    ]

    chart.polyline(points).should eq("20.0,20.0 580.0,220.0")
  end
end
