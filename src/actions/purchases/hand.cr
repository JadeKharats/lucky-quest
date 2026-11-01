class Purchases::Hand < BrowserAction
  include Auth::RequireFamilyManager

  post "/boutique/achats/:purchase_id/remis" do
    purchase = PurchaseQuery.to_hand_over.find(purchase_id)
    Purchase::SaveOperation.update!(purchase, handed_at: Time.utc)
    flash.success = "« #{purchase.reward.title} » remise à #{purchase.user.name}."
    redirect Rewards::Index
  end
end
