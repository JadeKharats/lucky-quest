class RaidQuery < Raid::BaseQuery
  def self.active : self
    new.archived_at.is_nil.title.asc_order.id.asc_order
  end
end
