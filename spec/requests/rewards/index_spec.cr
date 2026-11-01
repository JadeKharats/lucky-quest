require "../../spec_helper"

describe Rewards::Index do
  it "shows a child the rewards and her balance" do
    lina = child
    earn(lina, 120)
    RewardFactory.create &.title("30 min d'écran").cost(80)

    response = AppClient.new.exec(Rewards::Index, backdoor_user_id: lina.id)

    response.status_code.should eq(200)
    response.body.should contain("30 min d&#39;écran")
    response.body.should contain("120 XP")
  end

  it "shows the parents the purchases to hand over" do
    lina = child("Lina")
    reward = RewardFactory.create &.title("Choisir le film")
    Purchase::SaveOperation.create!(reward_id: reward.id, user_id: lina.id, cost: 100, bought_at: Time.utc)

    response = AppClient.new.exec(Rewards::Index, backdoor_user_id: UserFactory.create.id)

    response.body.should contain("À remettre")
    response.body.should contain("Choisir le film")
    response.body.should contain("Lina")
  end

  it "does not exist for a guest" do
    AppClient.new.exec(Rewards::Index, backdoor_user_id: guest.id).status_code.should eq(404)
  end
end
