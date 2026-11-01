class XpEntryQuery < XpEntry::BaseQuery
  def self.earned_by(member : User) : Int32
    new.user_id(member.id).amount.select_sum!.to_i
  end
end
