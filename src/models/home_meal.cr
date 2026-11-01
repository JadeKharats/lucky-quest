# What is planned at home for one slot of one day.
class HomeMeal < BaseModel
  table do
    column day : Time
    column slot : Meals::Slot
    column dish : String
    column tag : Meals::MainTag
  end

  def to_domain : Meals::HomeMeal
    Meals::HomeMeal.new(day: day, slot: slot, dish: Meals::Dish.new(name: dish, tag: tag))
  end
end
