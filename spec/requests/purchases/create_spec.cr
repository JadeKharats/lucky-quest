require "../../spec_helper"

describe Purchases::Create do
  it "lets a child buy a reward she can afford" do
    lina = child
    earn(lina, 120)
    reward = RewardFactory.create &.cost(100)

    response = AppClient.new.exec(Purchases::Create.with(reward.id), backdoor_user_id: lina.id)

    response.headers["Location"].should eq(Rewards::Index.path)
    purchase = PurchaseQuery.new.first
    {purchase.user_id, purchase.cost, purchase.handed_at}.should eq({lina.id, 100, nil})
  end

  it "refuses a reward she cannot afford" do
    lina = child
    earn(lina, 120)
    Purchase::SaveOperation.create!(reward_id: RewardFactory.create.id, user_id: lina.id, cost: 100, bought_at: Time.utc)
    reward = RewardFactory.create &.cost(30)

    AppClient.new.exec(Purchases::Create.with(reward.id), backdoor_user_id: lina.id)

    PurchaseQuery.new.select_count.should eq(1)
  end

  it "does not exist for a parent or for an archived reward" do
    parent = UserFactory.create
    earn(parent, 500)
    lina = child
    earn(lina, 500)
    reward = RewardFactory.create
    archived = RewardFactory.create &.archived_at(Time.utc)

    AppClient.new.exec(Purchases::Create.with(reward.id), backdoor_user_id: parent.id).status_code.should eq(404)
    AppClient.new.exec(Purchases::Create.with(archived.id), backdoor_user_id: lina.id).status_code.should eq(404)
    PurchaseQuery.new.select_count.should eq(0)
  end
end
