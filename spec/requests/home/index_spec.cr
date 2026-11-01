require "../../spec_helper"

describe Home::Index do
  it "takes a parent to the weight log" do
    response = AppClient.new.exec(Home::Index, backdoor_user_id: UserFactory.create.id)

    response.headers["Location"].should eq(Weighings::Index.path)
  end

  it "welcomes a child by name" do
    response = AppClient.new.exec(Home::Index, backdoor_user_id: child("Lina").id)

    response.status_code.should eq(200)
    response.body.should contain("Bonjour Lina")
    response.body.should_not contain(Weighings::Index.path)
    response.body.should_not contain(Members::Index.path)
  end

  it "sends visitors to the sign-in page" do
    response = AppClient.new.exec(Home::Index)

    response.headers["Location"].should eq(SignIns::New.path)
  end
end
