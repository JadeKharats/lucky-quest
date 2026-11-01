# One occurrence cancelled, or driven by other people than usual (when
# `drivers_overridden`; then nil means nobody).
class ActivityChange < BaseModel
  table do
    belongs_to activity : Activity
    column day : Time
    column cancelled : Bool = false
    column drivers_overridden : Bool = false
    belongs_to driver_to : User?
    belongs_to driver_back : User?
  end

  def to_domain : Agenda::Change
    drivers = Agenda::Drivers.new(to: driver_to_id, back: driver_back_id) if drivers_overridden
    Agenda::Change.new(activity_id: activity_id, day: day.in(Household::TIME_ZONE), cancelled: cancelled, drivers: drivers)
  end
end
