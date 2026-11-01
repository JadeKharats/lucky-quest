class PurchaseQuery < Purchase::BaseQuery
  def self.spent_by(member : User) : Int32
    new.user_id(member.id).cost.select_sum!.to_i
  end

  def self.to_hand_over : self
    new.handed_at.is_nil.bought_at.asc_order.preload_reward.preload_user
  end
end
