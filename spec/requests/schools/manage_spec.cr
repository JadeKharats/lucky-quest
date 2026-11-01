require "../../spec_helper"

describe "Schools" do
  it "lets a parent add a school with its canteen days" do
    AppClient.new.exec(Schools::Create, backdoor_user_id: UserFactory.create.id,
      school: {name: "École du Parc", days: ["1", "2", "4", "5"]})

    created = SchoolQuery.new.first
    {created.name, created.days_mask}.should eq({"École du Parc", 0b0011011})
  end

  it "needs a name and at least one canteen day" do
    AppClient.new.exec(Schools::Create, backdoor_user_id: UserFactory.create.id, school: {name: "Collège"})

    SchoolQuery.new.select_count.should eq(0)
  end

  it "lets a parent link a daughter to her school" do
    parc = school
    lina = child("Lina")

    AppClient.new.exec(Members::Update.with(lina.id), backdoor_user_id: UserFactory.create.id,
      member: {name: "Lina", last_day: "", school_id: parc.id.to_s})

    lina.reload.school_id.should eq(parc.id)
  end

  it "does not exist for a child" do
    AppClient.new.exec(Schools::Create, backdoor_user_id: child.id,
      school: {name: "École", days: ["1"]}).status_code.should eq(404)
    SchoolQuery.new.select_count.should eq(0)
  end
end
