# One slot of the home plan: a dish and its tag, or nothing.
class SaveHomeMeal < Avram::Operation
  param_key :home_meal

  needs day : Time
  needs slot : Meals::Slot

  attribute dish : String
  attribute tag : String

  def run
    name = dish.value.to_s.strip
    existing = HomeMealQuery.new.day(day).slot(slot).first?
    return clear(existing) if name.empty?

    chosen = Meals::MainTag.parse?(tag.value.to_s)
    unless chosen
      tag.add_error "Choisissez le type de plat."
      return false
    end
    if existing
      HomeMeal::SaveOperation.update!(existing, dish: name, tag: chosen)
    else
      HomeMeal::SaveOperation.create!(day: day, slot: slot, dish: name, tag: chosen)
    end
    true
  end

  private def clear(existing : HomeMeal?) : Bool
    existing.try { |meal| HomeMeal::DeleteOperation.delete!(meal) }
    true
  end
end
