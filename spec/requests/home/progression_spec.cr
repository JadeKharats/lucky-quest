require "../../spec_helper"

describe "Progression on the home page" do
  it "shows a child her rank, XP, streak and balance" do
    lina = child
    quest = QuestFactory.create &.user_id(lina.id)
    CompletionFactory.create &.quest_id(quest.id)
    earn(lina, 200)

    body = AppClient.new.exec(Home::Index, backdoor_user_id: lina.id).body

    body.should contain("Rang D")
    body.should contain("200 XP")
    body.should contain("encore 300 XP pour le rang C")
    body.should match(/<span class="streak">.*1 jour<\/span>/)
    body.should contain(Rewards::Index.path)
  end

  it "shows no progression to a guest" do
    AppClient.new.exec(Home::Index, backdoor_user_id: guest.id).body.should_not contain("progress-rank")
  end
end
