# How numbers and dates read on a French screen.
module French
  extend self

  MONTHS = %w[janv. févr. mars avr. mai juin juil. août sept. oct. nov. déc.]

  def kilograms(value : Float64) : String
    "#{decimal(value)} kg"
  end

  # "−0,4 kg" with a true minus sign, "+0,3 kg", "0,0 kg".
  def delta(value : Float64) : String
    rounded = value.round(1)
    sign = rounded.negative? ? "−" : (rounded.positive? ? "+" : "")
    "#{sign}#{kilograms(rounded.abs)}"
  end

  def date(time : Time) : String
    "#{time.day} #{MONTHS[time.month - 1]}"
  end

  def date_time(time : Time) : String
    "#{date(time)} à #{time.to_s("%H:%M")}"
  end

  private def decimal(value : Float64) : String
    value.round(1).format(decimal_places: 1).tr(".", ",")
  end
end
