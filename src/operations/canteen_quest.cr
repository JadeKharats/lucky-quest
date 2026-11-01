# Once a daughter has filled every canteen day of next week, her "menu de la
# cantine" quests are done for this period (a parent or a guest validates).
module CanteenQuest
  extend self

  def check(member : User, school : School, now : Time = Time.local(Household::TIME_ZONE)) : Nil
    next_week = school.week(now.at_beginning_of_week.shift(days: 7))
    filled = CanteenMealQuery.between(next_week.monday, next_week.monday.shift(days: 7)).school_id(school.id).map(&.day)
    return unless next_week.complete?(filled)

    QuestQuery.active.user_id(member.id).canteen_menu(true).each do |quest|
      next unless quest.recurrence.due_on?(now)
      period = quest.recurrence.period_start(now)
      next if CompletionQuery.new.quest_id(quest.id).period_start(period).first?
      CompleteQuest.create!(quest_id: quest.id, member: member, period: period)
    end
  end
end
