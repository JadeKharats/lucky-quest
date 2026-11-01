require "../../spec_helper"

describe Weighings::Delete do
  it "deletes one of the owner's weighings" do
    owner = UserFactory.create
    weighing = WeighingFactory.create &.user_id(owner.id)

    response = AppClient.new.exec(Weighings::Delete.with(weighing.id), backdoor_user_id: owner.id)

    response.status_code.should eq(302)
    WeighingQuery.new.select_count.should eq(0)
  end

  it "answers 404 for another account's weighing and keeps it" do
    owner = UserFactory.create
    weighing = WeighingFactory.create &.user_id(UserFactory.create.id)

    response = AppClient.new.exec(Weighings::Delete.with(weighing.id), backdoor_user_id: owner.id)

    response.status_code.should eq(404)
    WeighingQuery.new.select_count.should eq(1)
  end
end
