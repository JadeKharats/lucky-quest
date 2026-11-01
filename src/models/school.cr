# One of the two canteens, with the days it serves lunch.
class School < BaseModel
  table do
    column name : String
    # Bit 0 = Monday … bit 6 = Sunday.
    column days_mask : Int32
  end

  def days : Array(Time::DayOfWeek)
    Meals::CanteenWeek.days_of(days_mask)
  end

  def week(day : Time) : Meals::CanteenWeek
    Meals::CanteenWeek.new(days, day)
  end
end
