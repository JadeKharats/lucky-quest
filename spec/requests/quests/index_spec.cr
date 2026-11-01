require "../../spec_helper"

describe Quests::Index do
  it "lists every member's quests for a parent" do
    parent = UserFactory.create
    QuestFactory.create &.user_id(child("Lina").id).title("Aider en cuisine")
    QuestFactory.create &.user_id(child("Emma").id).title("Mettre la table")

    response = AppClient.new.exec(Quests::Index, backdoor_user_id: parent.id)

    response.status_code.should eq(200)
    response.body.should contain("Aider en cuisine")
    response.body.should contain("Mettre la table")
  end

  it "does not exist for a child or a guest" do
    [child, guest].each do |member|
      AppClient.new.exec(Quests::Index, backdoor_user_id: member.id).status_code.should eq(404)
    end
  end
end
