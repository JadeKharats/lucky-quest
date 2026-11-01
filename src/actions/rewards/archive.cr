class Rewards::Archive < BrowserAction
  include Auth::RequireFamilyManager

  post "/boutique/recompenses/:reward_id/archive" do
    reward = RewardQuery.active.find(reward_id)
    Reward::SaveOperation.update!(reward, archived_at: Time.utc)
    flash.success = "Récompense « #{reward.title} » retirée de la boutique."
    redirect Rewards::Index
  end
end
