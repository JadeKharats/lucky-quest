require "../../spec_helper"

describe Validations::Index do
  it "shows a guest the quests waiting for a validation" do
    lina = child("Lina")
    quest = QuestFactory.create &.user_id(lina.id).title("Mettre la table")
    CompletionFactory.create &.quest_id(quest.id)

    response = AppClient.new.exec(Validations::Index, backdoor_user_id: guest.id)

    response.status_code.should eq(200)
    response.body.should contain("Mettre la table")
    response.body.should contain("Lina")
  end

  it "does not exist for a child" do
    AppClient.new.exec(Validations::Index, backdoor_user_id: child.id).status_code.should eq(404)
  end
end
