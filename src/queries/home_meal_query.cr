class HomeMealQuery < HomeMeal::BaseQuery
  def self.between(from : Time, to : Time) : self
    new.day.gte(from).day.lt(to)
  end

  # Names already used, for the dish field's suggestions.
  def self.known_dishes : Array(String)
    new.updated_at.desc_order.limit(200).map(&.dish).uniq!.sort!
  end
end
