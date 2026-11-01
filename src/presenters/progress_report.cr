# A member's progression: rank from lifetime XP, streak, shop balance and
# the latest XP earned.
class ProgressReport
  STREAK_WINDOW_DAYS = 120
  RECENT             =   5

  getter standing : Progression::Standing
  getter streak : Int32
  getter wallet : Progression::Wallet
  getter recent : Array(XpEntry)

  def self.for(member : User, now : Time = Time.local(Household::TIME_ZONE)) : self
    earned = XpEntryQuery.earned_by(member)
    new(
      standing: Progression::Standing.new(xp: earned),
      streak: streak_of(member, now),
      wallet: Progression::Wallet.new(earned: earned, spent: PurchaseQuery.spent_by(member)),
      recent: XpEntryQuery.new.user_id(member.id).earned_at.desc_order.limit(RECENT).to_a,
    )
  end

  def initialize(@standing, @streak, @wallet, @recent)
  end

  # Days with a daily or chosen-days quest due (from its creation until its
  # archiving), and days on which one was done.
  private def self.streak_of(member : User, now : Time) : Int32
    quests = QuestQuery.new.user_id(member.id).to_a.reject(&.recurrence.weekly?)
    today = now.at_beginning_of_day
    window = (0..STREAK_WINDOW_DAYS).map { |back| today.shift(days: -back) }
    due = window.select { |day| quests.any? { |quest| due_on?(quest, day) } }
    done = CompletionQuery.new
      .quest_id.in(quests.map(&.id))
      .period_start.gte(window.last)
      .map(&.period_start)
    Progression::Streak.new(due: due, done: done, today: now).length
  end

  private def self.due_on?(quest : Quest, day : Time) : Bool
    created = quest.created_at.in(day.location).at_beginning_of_day
    archived = quest.archived_at
    created <= day && (archived.nil? || archived > day) && quest.recurrence.due_on?(day)
  end
end
