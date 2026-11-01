module Agenda
  enum Leg
    To   = 0
    Back = 1
  end

  # Who drives there (`to`) and back; nil when nobody has said yet.
  record Drivers, to : Int64?, back : Int64? do
    def for(leg : Leg) : Int64?
      leg.to? ? to : back
    end
  end

  # Weekly from `starts_on` (until `last_day`, included) or once on `starts_on`.
  # Times are Paris wall-clock minutes since midnight.
  record Activity, id : Int64, title : String, place : String, starts_on : Time,
    start_minutes : Int32, end_minutes : Int32, weekly : Bool, last_day : Time?,
    participant_ids : Array(Int64), needs_ride : Bool, usual : Drivers

  # One occurrence cancelled, or driven by other people than usual.
  record Change, activity_id : Int64, day : Time, cancelled : Bool, drivers : Drivers?
end
