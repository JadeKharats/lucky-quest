require "../../spec_helper"

describe Quests::Update do
  it "changes the title and the recurrence" do
    parent = UserFactory.create
    quest = QuestFactory.create &.user_id(child.id)

    response = AppClient.new.exec(Quests::Update.with(quest.id), backdoor_user_id: parent.id,
      quest: {title: "Débarrasser", frequency: "Weekly"})

    response.status_code.should eq(302)
    quest = quest.reload
    quest.title.should eq("Débarrasser")
    quest.recurrence.should eq(Quests::Recurrence.weekly)
  end

  it "does not exist for a child" do
    lina = child
    quest = QuestFactory.create &.user_id(lina.id)

    response = AppClient.new.exec(Quests::Update.with(quest.id), backdoor_user_id: lina.id,
      quest: {title: "Rien", frequency: "Weekly"})

    response.status_code.should eq(404)
    quest.reload.title.should eq("Mettre la table")
  end
end
