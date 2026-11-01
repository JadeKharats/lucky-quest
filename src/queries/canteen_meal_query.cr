class CanteenMealQuery < CanteenMeal::BaseQuery
  def self.between(from : Time, to : Time) : self
    new.day.gte(from).day.lt(to)
  end
end
