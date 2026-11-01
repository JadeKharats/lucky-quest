require "../../spec_helper"

private def purchase_of(member : User) : Purchase
  Purchase::SaveOperation.create!(reward_id: RewardFactory.create.id, user_id: member.id, cost: 100, bought_at: Time.utc)
end

describe "Handing over purchases" do
  it "lets a parent mark a purchase handed over" do
    purchase = purchase_of(child)

    AppClient.new.exec(Purchases::Hand.with(purchase.id), backdoor_user_id: UserFactory.create.id)

    purchase.reload.handed_at.should_not be_nil
  end

  it "lets a parent cancel a purchase not handed over yet, which gives the XP back" do
    lina = child
    earn(lina, 100)
    purchase = purchase_of(lina)

    AppClient.new.exec(Purchases::Delete.with(purchase.id), backdoor_user_id: UserFactory.create.id)

    PurchaseQuery.new.select_count.should eq(0)
  end

  it "keeps a purchase already handed over" do
    purchase = purchase_of(child)
    Purchase::SaveOperation.update!(purchase, handed_at: Time.utc)

    AppClient.new.exec(Purchases::Delete.with(purchase.id), backdoor_user_id: UserFactory.create.id).status_code.should eq(404)
    PurchaseQuery.new.select_count.should eq(1)
  end

  it "does not exist for a child" do
    lina = child
    purchase = purchase_of(lina)

    AppClient.new.exec(Purchases::Hand.with(purchase.id), backdoor_user_id: lina.id).status_code.should eq(404)
    AppClient.new.exec(Purchases::Delete.with(purchase.id), backdoor_user_id: lina.id).status_code.should eq(404)
    purchase.reload.handed_at.should be_nil
  end
end
