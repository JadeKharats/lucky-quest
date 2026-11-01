class Rewards::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/boutique/recompenses" do
    SaveReward.create(params) do |operation, reward|
      if reward
        flash.success = "Récompense « #{reward.title} » ajoutée."
      else
        flash.failure = operation.errors.values.flatten.first? || "Récompense non ajoutée."
      end
      redirect Rewards::Index
    end
  end
end
