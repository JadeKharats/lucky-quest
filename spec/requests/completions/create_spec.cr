require "../../spec_helper"

describe Completions::Create do
  it "marks a child's quest done, waiting for a validation" do
    lina = child
    quest = QuestFactory.create &.user_id(lina.id)

    response = AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: lina.id)

    response.headers["Location"].should eq(Home::Index.path)
    completion = CompletionQuery.new.quest_id(quest.id).first
    completion.period_start.should eq(today_in_paris.at_beginning_of_day)
    completion.validated_at.should be_nil
  end

  it "validates a parent's own quest at once" do
    parent = UserFactory.create
    quest = QuestFactory.create &.user_id(parent.id).title("30 min de marche")

    AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: parent.id)

    completion = CompletionQuery.new.quest_id(quest.id).first
    completion.validated_at.should_not be_nil
    completion.validated_by_id.should eq(parent.id)
  end

  it "counts a weekly quest once for the whole week" do
    lina = child
    quest = QuestFactory.create &.user_id(lina.id).frequency(Quests::Frequency::Weekly)

    AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: lina.id)

    CompletionQuery.new.first.period_start.should eq(today_in_paris.at_beginning_of_week)
  end

  it "does nothing the second time" do
    lina = child
    quest = QuestFactory.create &.user_id(lina.id)
    AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: lina.id)

    response = AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: lina.id)

    response.status_code.should eq(302)
    CompletionQuery.new.select_count.should eq(1)
  end

  it "answers 404 for a sister's quest" do
    quest = QuestFactory.create &.user_id(child("Emma").id)

    response = AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: child("Lina").id)

    response.status_code.should eq(404)
    CompletionQuery.new.select_count.should eq(0)
  end

  it "answers 404 for a quest that is not due today or is archived" do
    lina = child
    mask = Quests::Recurrence.on(Time::DayOfWeek.values.reject(today_in_paris.day_of_week)).mask
    not_due = QuestFactory.create &.user_id(lina.id).frequency(Quests::Frequency::Weekdays).days_mask(mask)
    archived = QuestFactory.create &.user_id(lina.id).archived_at(Time.utc)

    [not_due, archived].each do |quest|
      AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: lina.id).status_code.should eq(404)
    end
    CompletionQuery.new.select_count.should eq(0)
  end
end
