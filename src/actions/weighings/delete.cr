class Weighings::Delete < BrowserAction
  delete "/poids/:weighing_id" do
    # Scoped to the owner: someone else's weighing is "not found" (404).
    weighing = WeighingQuery.owned_by(current_user).find(weighing_id)
    Weighing::DeleteOperation.delete!(weighing)
    flash.success = "Pesée supprimée."
    redirect Index
  end
end
