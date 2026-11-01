# How far into the current rank, drawn in the skin's way: a bar, system
# segments, paws or footprints.
class Shared::Meter < BaseComponent
  needs progress : Float64
  needs skin : Appearance::Skin
  needs label : String

  def render
    div class: "meter meter-#{skin.to_s.downcase}", role: "img", "aria-label": label do
      case skin
      in .classic? then bar
      in .system?  then steps(20) { span class: "meter-step" }
      in .animals? then steps(10) { raw Shared::Art::PAW }
      in .dance?   then steps(10) { raw Shared::Art::FOOTPRINT }
      end
    end
  end

  # How many of `count` steps are lit.
  def lit(count : Int32) : Int32
    (progress * count).floor.to_i.clamp(0, count)
  end

  private def bar
    div class: "bar" do
      div class: "bar-fill", style: "width: #{(progress * 100).to_i}%"
    end
  end

  private def steps(count : Int32, &)
    on = lit(count)
    count.times do |index|
      span class: index < on ? "meter-cell meter-on" : "meter-cell" do
        yield
      end
    end
  end
end
