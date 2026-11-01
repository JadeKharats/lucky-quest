class Quests::Index < BrowserAction
  include Auth::RequireFamilyManager

  get "/quetes" do
    html IndexPage, operation: CreateQuest.new, members: QuestBoard.members
  end
end
