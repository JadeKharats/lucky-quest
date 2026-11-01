class Quests::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/quetes" do
    CreateQuest.create(params) do |operation, quest|
      if quest
        flash.success = "Quête « #{quest.title} » ajoutée."
        redirect Quests::Index
      else
        html_with_status IndexPage, 422, operation: operation, members: QuestBoard.members
      end
    end
  end
end
