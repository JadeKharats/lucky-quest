# One line of a member's XP ledger: a validated quest or a finished raid.
class XpEntry < BaseModel
  table do
    belongs_to user : User
    column amount : Int32
    column label : String
    column earned_at : Time
    belongs_to completion : Completion?
    belongs_to raid : Raid?
    column period_start : Time?
  end
end
