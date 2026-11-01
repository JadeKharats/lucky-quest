require "../../spec_helper"

describe Validations::Create do
  it "lets a guest validate a child's quest" do
    mamie = guest
    completion = CompletionFactory.create &.quest_id(QuestFactory.create(&.user_id(child.id)).id)

    response = AppClient.new.exec(Validations::Create.with(completion.id), backdoor_user_id: mamie.id)

    response.headers["Location"].should eq(Validations::Index.path)
    completion = completion.reload
    completion.validated_at.should_not be_nil
    completion.validated_by_id.should eq(mamie.id)
  end

  it "does not let a child validate her own quest" do
    lina = child
    completion = CompletionFactory.create &.quest_id(QuestFactory.create(&.user_id(lina.id)).id)

    response = AppClient.new.exec(Validations::Create.with(completion.id), backdoor_user_id: lina.id)

    response.status_code.should eq(404)
    completion.reload.validated_at.should be_nil
  end
end
