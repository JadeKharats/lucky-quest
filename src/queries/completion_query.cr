class CompletionQuery < Completion::BaseQuery
  # Done by a child, not validated yet (a parent's own are validated at once).
  def self.awaiting_validation : self
    new.validated_at.is_nil.done_at.asc_order.preload_quest(QuestQuery.new.preload_user)
  end
end
