require "../../spec_helper"

describe Validations::Delete do
  it "sends a quest back to à faire" do
    completion = CompletionFactory.create &.quest_id(QuestFactory.create(&.user_id(child.id)).id)

    response = AppClient.new.exec(Validations::Delete.with(completion.id), backdoor_user_id: UserFactory.create.id)

    response.headers["Location"].should eq(Validations::Index.path)
    CompletionQuery.new.select_count.should eq(0)
  end

  it "keeps a validated quest" do
    parent = UserFactory.create
    completion = CompletionFactory.create &.quest_id(QuestFactory.create(&.user_id(child.id)).id).validated_at(Time.utc).validated_by_id(parent.id)

    response = AppClient.new.exec(Validations::Delete.with(completion.id), backdoor_user_id: parent.id)

    response.status_code.should eq(404)
    CompletionQuery.new.select_count.should eq(1)
  end

  it "does not exist for a child" do
    lina = child
    completion = CompletionFactory.create &.quest_id(QuestFactory.create(&.user_id(lina.id)).id)

    AppClient.new.exec(Validations::Delete.with(completion.id), backdoor_user_id: lina.id).status_code.should eq(404)
    CompletionQuery.new.select_count.should eq(1)
  end
end
