# "C'est fait !" on one of the member's own quests, for today's occurrence
# (or this week's). Someone else's, archived or not-due quest → 404.
class Completions::Create < BrowserAction
  post "/quetes/:quest_id/fait" do
    quest = QuestQuery.active.user_id(current_user.id).find(quest_id)
    today = Time.local(Household::TIME_ZONE)
    raise Lucky::RouteNotFoundError.new(context) unless quest.recurrence.due_on?(today)

    period = quest.recurrence.period_start(today)
    unless CompletionQuery.new.quest_id(quest.id).period_start(period).first?
      CompleteQuest.create!(quest_id: quest.id, member: current_user, period: period)
      flash.success = "Bravo, « #{quest.title} » est faite !"
    end
    redirect Home::Index
  end
end
