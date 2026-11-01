# Writes the change of one occurrence: cancelled, or other drivers.
module ActivityChanges
  extend self

  def cancel(occurrence : Agenda::Occurrence, cancelled : Bool) : Nil
    upsert(occurrence, &.merge(cancelled: cancelled))
  end

  def set_driver(occurrence : Agenda::Occurrence, leg : Agenda::Leg, driver_id : Int64?) : Nil
    drivers = leg.to? ? occurrence.drivers.copy_with(to: driver_id) : occurrence.drivers.copy_with(back: driver_id)
    upsert(occurrence) do |values|
      values.merge(drivers_overridden: true, driver_to_id: drivers.to, driver_back_id: drivers.back)
    end
  end

  private def upsert(occurrence : Agenda::Occurrence, &)
    activity_id = occurrence.activity.id
    existing = ActivityChangeQuery.new.activity_id(activity_id).day(occurrence.day).first?
    current = {
      cancelled:          existing.try(&.cancelled) || false,
      drivers_overridden: existing.try(&.drivers_overridden) || false,
      driver_to_id:       existing.try(&.driver_to_id),
      driver_back_id:     existing.try(&.driver_back_id),
    }
    values = yield current
    if existing
      ActivityChange::SaveOperation.update!(existing, **values)
    else
      ActivityChange::SaveOperation.create!(**values.merge(activity_id: activity_id, day: occurrence.day))
    end
  end
end
