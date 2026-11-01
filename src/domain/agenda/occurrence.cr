module Agenda
  record Trip, occurrence : Occurrence, leg : Leg, driver_id : Int64?

  record Occurrence, activity : Activity, day : Time, starts_at : Time, ends_at : Time,
    cancelled : Bool, drivers : Drivers do
    def trips : Array(Trip)
      return [] of Trip unless activity.needs_ride
      Leg.values.map { |leg| Trip.new(self, leg, drivers.for(leg)) }
    end

    def driver_ids : Array(Int64)
      trips.compact_map(&.driver_id)
    end

    def involves?(member_id : Int64) : Bool
      activity.participant_ids.includes?(member_id) || driver_ids.includes?(member_id)
    end
  end
end
