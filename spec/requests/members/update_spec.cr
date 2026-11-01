require "../../spec_helper"

describe Members::Update do
  it "renames a member and moves a guest's last day" do
    parent = UserFactory.create
    member = guest

    response = AppClient.new.exec(Members::Update.with(member.id), backdoor_user_id: parent.id,
      member: {name: "Mamie Jo", last_day: "2027-01-03"})

    response.status_code.should eq(302)
    member = member.reload
    member.name.should eq("Mamie Jo")
    member.access_ends_at.should eq(Time.local(2027, 1, 4, location: Household::TIME_ZONE))
  end

  it "keeps a child without an end of access" do
    parent = UserFactory.create
    member = child

    AppClient.new.exec(Members::Update.with(member.id), backdoor_user_id: parent.id,
      member: {name: "Lina", last_day: "2027-01-03"})

    member.reload.access_ends_at.should be_nil
  end

  it "does not exist for a guest" do
    member = guest

    response = AppClient.new.exec(Members::Update.with(member.id), backdoor_user_id: member.id,
      member: {name: "Hacked", last_day: "2099-01-01"})

    response.status_code.should eq(404)
    member.reload.name.should eq("Mamie")
  end
end
