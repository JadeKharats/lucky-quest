class Quests::Update < BrowserAction
  include Auth::RequireFamilyManager

  patch "/quetes/:quest_id" do
    UpdateQuest.update(QuestQuery.active.find(quest_id), params) do |operation, quest|
      if operation.saved?
        flash.success = "Quête « #{quest.title} » mise à jour."
      else
        flash.failure = operation.errors.values.flatten.first? || "Rien n'a changé."
      end
      redirect Quests::Index
    end
  end
end
