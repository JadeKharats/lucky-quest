class Reward < BaseModel
  table do
    column title : String
    column cost : Int32
    column archived_at : Time?
  end
end
