require "../../spec_helper"

describe Members::Create do
  it "adds a child, who has no end of access" do
    parent = UserFactory.create

    response = AppClient.new.exec(Members::Create, backdoor_user_id: parent.id,
      member: {name: "Lina", role: "1", last_day: ""})

    response.status_code.should eq(302)
    member = UserQuery.new.name("Lina").first
    member.role.should eq(Family::Role::Child)
    member.access_ends_at.should be_nil
    member.email.should be_nil
  end

  it "adds a guest until the end of her last day, Paris time" do
    parent = UserFactory.create

    AppClient.new.exec(Members::Create, backdoor_user_id: parent.id,
      member: {name: "Mamie", role: "2", last_day: "2026-12-31"})

    member = UserQuery.new.name("Mamie").first
    member.role.should eq(Family::Role::Guest)
    member.access_ends_at.should eq(Time.local(2027, 1, 1, location: Household::TIME_ZONE))
  end

  it "asks for a guest's last day" do
    parent = UserFactory.create

    response = AppClient.new.exec(Members::Create, backdoor_user_id: parent.id,
      member: {name: "Mamie", role: "2", last_day: ""})

    response.status_code.should eq(422)
    response.body.should contain("Indiquez le dernier jour d&#39;accès.")
    UserQuery.new.name("Mamie").first?.should be_nil
  end

  it "asks for a name" do
    parent = UserFactory.create

    response = AppClient.new.exec(Members::Create, backdoor_user_id: parent.id,
      member: {name: "", role: "1", last_day: ""})

    response.status_code.should eq(422)
    UserQuery.new.select_count.should eq(1)
  end

  it "does not exist for a child" do
    response = AppClient.new.exec(Members::Create, backdoor_user_id: child.id,
      member: {name: "Intruder", role: "0", last_day: ""})

    response.status_code.should eq(404)
    UserQuery.new.name("Intruder").first?.should be_nil
  end
end
