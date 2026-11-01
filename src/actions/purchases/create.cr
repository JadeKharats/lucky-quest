# A child buys a reward: the cost leaves her balance at once, and the
# parents see it "à remettre".
class Purchases::Create < BrowserAction
  include Auth::RequireShop

  post "/boutique/recompenses/:reward_id/acheter" do
    raise Lucky::RouteNotFoundError.new(context) unless current_user.role.buy_rewards?
    reward = RewardQuery.active.find(reward_id)

    if ProgressReport.for(current_user).wallet.can_afford?(reward.cost)
      Purchase::SaveOperation.create!(reward_id: reward.id, user_id: current_user.id, cost: reward.cost, bought_at: Time.utc)
      flash.success = "« #{reward.title} » achetée ! Un parent va te la remettre."
    else
      flash.failure = "Il te manque encore des XP pour « #{reward.title} »."
    end
    redirect Rewards::Index
  end
end
