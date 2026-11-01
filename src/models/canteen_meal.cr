# A school's lunch on one day, copied by a daughter.
class CanteenMeal < BaseModel
  table do
    belongs_to school : School
    column day : Time
    column dish : String
    column tag : Meals::MainTag
  end

  def to_dish : Meals::Dish
    Meals::Dish.new(name: dish, tag: tag)
  end
end
