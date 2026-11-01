require "../../spec_helper"

describe Home::Index do
  it "shows a parent the weight shortcut and their own quests" do
    parent = UserFactory.create
    QuestFactory.create &.user_id(parent.id).title("30 min de marche")

    response = AppClient.new.exec(Home::Index, backdoor_user_id: parent.id)

    response.status_code.should eq(200)
    response.body.should contain(Weighings::Index.path)
    response.body.should contain("30 min de marche")
  end

  it "shows a child her quests, not her sister's, and no weight log" do
    lina = child("Lina")
    QuestFactory.create &.user_id(lina.id).title("Aider en cuisine")
    QuestFactory.create &.user_id(child("Emma").id).title("Mettre la table")

    response = AppClient.new.exec(Home::Index, backdoor_user_id: lina.id)

    response.body.should contain("Bonjour Lina")
    response.body.should contain("Aider en cuisine")
    response.body.should_not contain("Mettre la table")
    response.body.should_not contain(Weighings::Index.path)
    response.body.should_not contain(Members::Index.path)
  end

  it "shows a guest how many quests wait for her" do
    quest = QuestFactory.create &.user_id(child.id)
    CompletionFactory.create &.quest_id(quest.id)

    response = AppClient.new.exec(Home::Index, backdoor_user_id: guest.id)

    response.body.should contain("1 quête à valider")
    response.body.should contain(Validations::Index.path)
  end

  it "sends visitors to the sign-in page" do
    response = AppClient.new.exec(Home::Index)

    response.headers["Location"].should eq(SignIns::New.path)
  end
end
