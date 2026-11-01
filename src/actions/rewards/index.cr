class Rewards::Index < BrowserAction
  include Auth::RequireShop

  get "/boutique" do
    member = current_user
    html IndexPage,
      rewards: RewardQuery.active.to_a,
      operation: SaveReward.new,
      wallet: ProgressReport.for(member).wallet,
      purchases: member.role.buy_rewards? ? PurchaseQuery.new.user_id(member.id).bought_at.desc_order.limit(10).preload_reward.to_a : PurchaseQuery.to_hand_over.to_a
  end
end
