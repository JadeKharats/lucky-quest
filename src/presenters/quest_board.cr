# The parents' quest page: every member who has quests, with their active
# quests.
class QuestBoard
  record Row, member : User, quests : Array(Quest)

  def self.members : Array(Row)
    quests = QuestQuery.active.to_a.group_by(&.user_id)
    UserQuery.household.to_a
      .select(&.role.keep_quests?)
      .map { |member| Row.new(member, quests[member.id]? || [] of Quest) }
  end
end
