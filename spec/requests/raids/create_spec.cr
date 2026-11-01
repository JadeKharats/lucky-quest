require "../../spec_helper"

describe Raids::Create do
  it "lets a parent create a raid" do
    response = AppClient.new.exec(Raids::Create, backdoor_user_id: UserFactory.create.id,
      raid: {title: "Le Sol", frequency: "Weekly"})

    response.status_code.should eq(302)
    raid = RaidQuery.new.first
    raid.title.should eq("Le Sol")
    raid.recurrence.should eq(Quests::Recurrence.weekly)
  end

  it "does not exist for a child" do
    response = AppClient.new.exec(Raids::Create, backdoor_user_id: child.id,
      raid: {title: "Le Sol", frequency: "Weekly"})

    response.status_code.should eq(404)
    RaidQuery.new.select_count.should eq(0)
  end
end
