require "../../spec_helper"

describe Members::Index do
  it "lists the household for a parent" do
    parent = UserFactory.create &.name("David")
    child("Lina")
    guest

    response = AppClient.new.exec(Members::Index, backdoor_user_id: parent.id)

    response.status_code.should eq(200)
    response.body.should contain("Lina")
    response.body.should contain("Mamie")
    response.body.should contain("Enfant")
    response.body.should contain("Invité·e")
  end

  it "does not exist for a child or a guest" do
    [child, guest].each do |member|
      response = AppClient.new.exec(Members::Index, backdoor_user_id: member.id)

      response.status_code.should eq(404)
    end
  end
end
