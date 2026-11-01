# A daughter's copy of her school's lunches for one week: one dish and one
# tag per canteen day, in order. An empty dish removes that day's lunch.
class SaveCanteenWeek < Avram::Operation
  param_key :canteen_week

  needs school : School
  needs week : Meals::CanteenWeek

  attribute dishes : Array(String)
  attribute tags : Array(String)

  def run
    names = dishes.value || [] of String
    labels = tags.value || [] of String
    week.days.each_with_index do |day, index|
      save_day(day, names[index]?.to_s.strip, Meals::MainTag.parse?(labels[index]?.to_s) || Meals::MainTag::Other)
    end
    true
  end

  private def save_day(day : Time, name : String, tag : Meals::MainTag)
    existing = CanteenMealQuery.new.school_id(school.id).day(day).first?
    if name.empty?
      existing.try { |meal| CanteenMeal::DeleteOperation.delete!(meal) }
    elsif existing
      CanteenMeal::SaveOperation.update!(existing, dish: name, tag: tag)
    else
      CanteenMeal::SaveOperation.create!(school_id: school.id, day: day, dish: name, tag: tag)
    end
  end
end
