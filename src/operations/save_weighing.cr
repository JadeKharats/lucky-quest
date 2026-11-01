# Records a weighing for `owner`, from what was typed in the form: a weight
# such as "72,4" and a local date-time ("2026-11-01T08:30", Paris time).
class SaveWeighing < Weighing::SaveOperation
  param_key :weighing

  DATE_TIME_FORMAT = "%Y-%m-%dT%H:%M"

  needs owner : User

  attribute weight : String
  attribute measured_at_local : String

  before_save do
    user_id.value = owner.id
    read_weight
    read_measured_at
  end

  # The value the date-time field starts with: now, in Paris.
  def self.now_local : String
    Time.local(Household::TIME_ZONE).to_s(DATE_TIME_FORMAT)
  end

  private def read_weight
    if kilos = Health::Kilograms.parse?(weight.value.to_s)
      kilograms.value = kilos.value
    else
      weight.add_error "Indiquez un poids entre 20 et 300 kg, par exemple 72,4."
    end
  end

  private def read_measured_at
    measured_at.value = Time.parse(measured_at_local.value.to_s, DATE_TIME_FORMAT, Household::TIME_ZONE)
  rescue Time::Format::Error
    measured_at_local.add_error "Indiquez la date et heure de la pesée."
  end
end
