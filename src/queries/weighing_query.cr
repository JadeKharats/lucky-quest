class WeighingQuery < Weighing::BaseQuery
  # Every read of weighings goes through this scope: weight data is visible
  # to its owner only.
  def self.owned_by(user : User) : self
    new.user_id(user.id)
  end

  def since(time : Time) : self
    measured_at.gte(time)
  end

  def newest_first : self
    measured_at.desc_order
  end
end
