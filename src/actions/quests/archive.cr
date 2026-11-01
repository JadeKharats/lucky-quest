# Archived, not deleted: past completions stay (M5 counts them).
class Quests::Archive < BrowserAction
  include Auth::RequireFamilyManager

  post "/quetes/:quest_id/archive" do
    quest = QuestQuery.active.find(quest_id)
    ::Quest::SaveOperation.update!(quest, archived_at: Time.utc)
    flash.success = "Quête « #{quest.title} » archivée."
    redirect Quests::Index
  end
end
