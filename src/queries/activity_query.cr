class ActivityQuery < Activity::BaseQuery
  def self.ordered : self
    new.starts_on.asc_order.start_minutes.asc_order.id.asc_order
  end
end
