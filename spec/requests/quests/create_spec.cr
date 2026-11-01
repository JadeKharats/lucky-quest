require "../../spec_helper"

describe Quests::Create do
  it "gives a daily quest to a child" do
    parent = UserFactory.create
    lina = child

    response = AppClient.new.exec(Quests::Create, backdoor_user_id: parent.id,
      quest: {title: "Mettre la table", user_id: lina.id.to_s, frequency: "Daily"})

    response.status_code.should eq(302)
    quest = QuestQuery.new.user_id(lina.id).first
    quest.title.should eq("Mettre la table")
    quest.recurrence.should eq(Quests::Recurrence.daily)
  end

  it "stores the chosen days" do
    parent = UserFactory.create

    AppClient.new.exec(Quests::Create, backdoor_user_id: parent.id,
      quest: {title: "Aider en cuisine", user_id: child.id.to_s, frequency: "Weekdays", days: ["1", "5"]})

    QuestQuery.new.first.recurrence.should eq(Quests::Recurrence.on([Time::DayOfWeek::Monday, Time::DayOfWeek::Friday]))
  end

  it "asks for at least one day" do
    parent = UserFactory.create

    response = AppClient.new.exec(Quests::Create, backdoor_user_id: parent.id,
      quest: {title: "Aider en cuisine", user_id: child.id.to_s, frequency: "Weekdays"})

    response.status_code.should eq(422)
    response.body.should contain("Choisissez au moins un jour.")
    QuestQuery.new.select_count.should eq(0)
  end

  it "asks for a title" do
    parent = UserFactory.create

    response = AppClient.new.exec(Quests::Create, backdoor_user_id: parent.id,
      quest: {title: "", user_id: child.id.to_s, frequency: "Daily"})

    response.status_code.should eq(422)
    response.body.should contain("Donnez un titre à la quête.")
  end

  it "gives no quest to a guest" do
    parent = UserFactory.create

    response = AppClient.new.exec(Quests::Create, backdoor_user_id: parent.id,
      quest: {title: "Ranger", user_id: guest.id.to_s, frequency: "Daily"})

    response.status_code.should eq(422)
    response.body.should contain("Ce membre n&#39;a pas de quêtes.")
    QuestQuery.new.select_count.should eq(0)
  end

  it "does not exist for a child" do
    lina = child

    response = AppClient.new.exec(Quests::Create, backdoor_user_id: lina.id,
      quest: {title: "Rien", user_id: lina.id.to_s, frequency: "Daily"})

    response.status_code.should eq(404)
    QuestQuery.new.select_count.should eq(0)
  end
end
