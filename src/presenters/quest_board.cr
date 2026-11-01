# The parents' quest page: every member who has quests, with their active
# quests.
class QuestBoard
  record Row, member : User, quests : Array(Quest)
  record RaidRow, raid : Raid, steps : Array(RaidStep), participants : Hash(Int64, Array(Int64))

  def self.raids : Array(RaidRow)
    raids = RaidQuery.active.to_a
    steps = RaidStepQuery.of(raids.map(&.id)).to_a
    participants = RaidStepParticipantQuery.new.raid_step_id.in(steps.map(&.id)).id.asc_order.to_a
      .group_by(&.raid_step_id)
      .transform_values(&.map(&.user_id))
    raids.map { |raid| RaidRow.new(raid, steps.select { |step| step.raid_id == raid.id }, participants) }
  end

  def self.members : Array(Row)
    quests = QuestQuery.active.to_a.group_by(&.user_id)
    UserQuery.household.to_a
      .select(&.role.keep_quests?)
      .map { |member| Row.new(member, quests[member.id]? || [] of Quest) }
  end
end
