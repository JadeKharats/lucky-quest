# Cancelling gives the XP back: the balance is earned minus purchases.
class Purchases::Delete < BrowserAction
  include Auth::RequireFamilyManager

  delete "/boutique/achats/:purchase_id" do
    purchase = PurchaseQuery.to_hand_over.find(purchase_id)
    Purchase::DeleteOperation.delete!(purchase)
    flash.info = "Achat de « #{purchase.reward.title} » annulé : #{purchase.user.name} récupère #{purchase.cost} XP."
    redirect Rewards::Index
  end
end
