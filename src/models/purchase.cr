# A reward a child bought; the cost is copied, so changing the reward later
# does not change what she paid.
class Purchase < BaseModel
  table do
    belongs_to reward : Reward
    belongs_to user : User
    column cost : Int32
    column bought_at : Time
    column handed_at : Time?
  end
end
