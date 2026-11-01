require "../../spec_helper"

describe Quests::Archive do
  it "takes the quest off the member's home" do
    parent = UserFactory.create
    lina = child
    quest = QuestFactory.create &.user_id(lina.id).title("Ranger la chambre")

    response = AppClient.new.exec(Quests::Archive.with(quest.id), backdoor_user_id: parent.id)

    response.status_code.should eq(302)
    quest.reload.archived_at.should_not be_nil
    home = AppClient.new.exec(Home::Index, backdoor_user_id: lina.id)
    home.body.should_not contain("Ranger la chambre")
  end

  it "does not exist for a child" do
    lina = child
    quest = QuestFactory.create &.user_id(lina.id)

    AppClient.new.exec(Quests::Archive.with(quest.id), backdoor_user_id: lina.id).status_code.should eq(404)
    quest.reload.archived_at.should be_nil
  end
end
