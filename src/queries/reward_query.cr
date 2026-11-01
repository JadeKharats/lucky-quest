class RewardQuery < Reward::BaseQuery
  def self.active : self
    new.archived_at.is_nil.cost.asc_order.title.asc_order
  end
end
