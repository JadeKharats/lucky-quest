# Writes the XP ledger where quests get validated and raids get finished.
module XpLedger
  extend self

  def award(completion : Completion) : Nil
    return if XpEntryQuery.new.completion_id(completion.id).first?

    quest = QuestQuery.find(completion.quest_id)
    XpEntry::SaveOperation.create!(user_id: quest.user_id, amount: quest.xp, label: quest.title,
      earned_at: completion.validated_at || Time.utc, completion_id: completion.id)
  end

  # Every participant earns the raid's XP while it is finished in this
  # period; if it is not finished anymore, that XP is taken back.
  def sync_raid(raid_id : Int64, now : Time = Time.local(Household::TIME_ZONE)) : Nil
    raid = RaidQuery.new.id(raid_id).first?
    return unless raid

    view = RaidBoard.for_raid(raid, now)
    entries = XpEntryQuery.new.raid_id(raid.id).period_start(view.period_start)
    if view.progress.finished?
      awarded = entries.map(&.user_id)
      view.raid.steps.flat_map(&.participant_ids).uniq!.reject { |id| awarded.includes?(id) }.each do |user_id|
        XpEntry::SaveOperation.create!(user_id: user_id, amount: raid.xp, label: "Raid : #{raid.title}",
          earned_at: Time.utc, raid_id: raid.id, period_start: view.period_start)
      end
    else
      entries.delete
    end
  end
end
