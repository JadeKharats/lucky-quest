require "../../spec_helper"

describe "Managing rewards" do
  it "lets a parent add a reward and archive it" do
    parent = UserFactory.create

    AppClient.new.exec(Rewards::Create, backdoor_user_id: parent.id, reward: {title: "Glace", cost: "60"})

    reward = RewardQuery.new.first
    {reward.title, reward.cost}.should eq({"Glace", 60})

    AppClient.new.exec(Rewards::Archive.with(reward.id), backdoor_user_id: parent.id)

    reward.reload.archived_at.should_not be_nil
  end

  it "refuses a reward without a positive cost" do
    AppClient.new.exec(Rewards::Create, backdoor_user_id: UserFactory.create.id, reward: {title: "Glace", cost: "0"})

    RewardQuery.new.select_count.should eq(0)
  end

  it "does not exist for a child" do
    lina = child

    AppClient.new.exec(Rewards::Create, backdoor_user_id: lina.id, reward: {title: "Tout", cost: "1"}).status_code.should eq(404)
    RewardQuery.new.select_count.should eq(0)
  end
end
