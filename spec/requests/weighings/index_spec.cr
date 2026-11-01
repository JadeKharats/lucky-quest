require "../../spec_helper"

describe Weighings::Index do
  it "shows the owner's weighings, the French way" do
    owner = UserFactory.create
    WeighingFactory.create &.user_id(owner.id).kilograms(72.4)

    response = AppClient.new.exec(Weighings::Index, backdoor_user_id: owner.id)

    response.status_code.should eq(200)
    response.body.should contain("72,4 kg")
  end

  it "never shows another account's weighings" do
    owner = UserFactory.create
    WeighingFactory.create &.user_id(UserFactory.create.id).kilograms(88.8)

    response = AppClient.new.exec(Weighings::Index, backdoor_user_id: owner.id)

    response.body.should_not contain("88,8")
  end

  it "sends guests to the sign-in page" do
    response = AppClient.new.exec(Weighings::Index)

    response.status_code.should eq(302)
    response.headers["Location"].should eq(SignIns::New.path)
  end
end
