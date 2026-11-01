# Each member's rank for the parents' Famille page; guests have none.
module Standings
  def self.of(members : Array(User)) : Hash(Int64, Progression::Standing)
    members.select(&.role.keep_quests?).to_h do |member|
      {member.id, Progression::Standing.new(xp: XpEntryQuery.earned_by(member))}
    end
  end
end
