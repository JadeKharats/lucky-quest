class UserQuery < User::BaseQuery
  # Parents first, then children, then guests; by name within a role.
  def self.household : self
    new.role.asc_order.name.asc_order
  end
end
