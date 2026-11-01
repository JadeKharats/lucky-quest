# The last 90 days as an SVG curve: daily weights (points and thin line)
# and the 7-day moving average (thick line). Rendered server-side, no JS.
class Weighings::Curve < BaseComponent
  needs report : WeightReport

  def render
    daily = in_range(report.summary.daily)
    return if daily.empty?

    averages = in_range(report.summary.averages)
    chart = WeightChart.new(
      from: report.curve_from,
      to: report.curve_to,
      kilograms: (daily + averages).map(&.kilograms))

    section class: "curve" do
      tag "svg", options: {"viewBox" => "0 0 #{WeightChart::WIDTH.to_i} #{WeightChart::HEIGHT.to_i}"},
        role: "img", aria_label: "Courbe du poids sur #{WeightReport::CURVE_DAYS} jours" do
        axis_label chart.max_kilograms, y: 14
        axis_label chart.min_kilograms, y: WeightChart::HEIGHT - 4
        tag "polyline", points: chart.polyline(daily), class: "curve-daily"
        tag "polyline", points: chart.polyline(averages), class: "curve-average"
        daily.each do |point|
          tag "circle", cx: chart.x(point.date).round(1).to_s, cy: chart.y(point.kilograms).round(1).to_s,
            r: "3", class: "curve-point"
        end
      end
      para class: "curve-legend" do
        span "● pesées", class: "legend-daily"
        span "— moyenne sur 7 jours", class: "legend-average"
      end
    end
  end

  private def in_range(points : Array(Health::DailyWeight)) : Array(Health::DailyWeight)
    points.select { |point| point.date >= report.curve_from }
  end

  private def axis_label(kilograms : Float64, y : Float64)
    tag "text", French.kilograms(kilograms), x: "4", y: y.to_s, class: "curve-axis"
  end
end
