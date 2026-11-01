# Geometry of the weight curve: places dates (x) and weights (y) in an SVG
# viewBox. Heavier is higher; half a kilo of margin keeps a flat line visible.
class WeightChart
  WIDTH   = 600.0
  HEIGHT  = 240.0
  PADDING =  20.0
  MARGIN  =   0.5

  getter min_kilograms : Float64
  getter max_kilograms : Float64

  def initialize(@from : Time, @to : Time, kilograms : Array(Float64))
    @min_kilograms = kilograms.min - MARGIN
    @max_kilograms = kilograms.max + MARGIN
  end

  def x(time : Time) : Float64
    PADDING + (time - @from) / (@to - @from) * (WIDTH - 2 * PADDING)
  end

  def y(kilograms : Float64) : Float64
    share = (kilograms - min_kilograms) / (max_kilograms - min_kilograms)
    HEIGHT - PADDING - share * (HEIGHT - 2 * PADDING)
  end

  def polyline(points : Array(Health::DailyWeight)) : String
    points.join(" ") { |point| "#{x(point.date).round(1)},#{y(point.kilograms).round(1)}" }
  end
end
