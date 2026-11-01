class RaidStepQuery < RaidStep::BaseQuery
  def self.of(raid_ids : Array(Int64)) : self
    new.raid_id.in(raid_ids).position.asc_order.id.asc_order
  end
end
