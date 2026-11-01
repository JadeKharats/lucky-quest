# An outside activity (dance, yoga, riding) or a one-off event.
class Activity < BaseModel
  table do
    column title : String
    column place : String = "", allow_blank: true
    column starts_on : Time
    column last_day : Time?
    column start_minutes : Int32
    column end_minutes : Int32
    column weekly : Bool
    column needs_ride : Bool
    belongs_to driver_to : User?
    belongs_to driver_back : User?
  end
end
