class RaidStep < BaseModel
  table do
    belongs_to raid : Raid
    column position : Int32
    column title : String
    column rule : Quests::StepRule
  end
end
