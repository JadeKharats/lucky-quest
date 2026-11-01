class SchoolQuery < School::BaseQuery
  def self.ordered : self
    new.name.asc_order.id.asc_order
  end
end
