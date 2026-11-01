class Rewards::IndexPage < MainLayout
  needs rewards : Array(Reward)
  needs operation : SaveReward
  needs wallet : Progression::Wallet
  needs purchases : Array(Purchase)

  def page_title
    "Boutique"
  end

  def content
    h1 "Boutique"
    if current_user.role.buy_rewards?
      mount Rewards::Shelf, rewards: rewards, wallet: wallet
      mount Rewards::MyPurchases, purchases: purchases
    else
      mount Rewards::ToHandOver, purchases: purchases
      mount Rewards::Manage, rewards: rewards, operation: operation
    end
  end
end
