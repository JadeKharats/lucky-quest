class SaveSchool < School::SaveOperation
  param_key :school

  permit_columns name
  # Canteen days as checkbox values "1" (Monday) … "7" (Sunday).
  attribute days : Array(Int32)

  before_save do
    validate_required name, message: "Donnez le nom de l'école."
    chosen = (days.value || [] of Int32).compact_map { |value| Time::DayOfWeek.from_value?(value) }
    if chosen.empty?
      days.add_error "Choisissez au moins un jour de cantine."
    else
      days_mask.value = Quests::Recurrence.on(chosen).mask
    end
  end

  def self.form_for(school : School) : self
    new(school, days: school.days.map(&.value))
  end
end
