class SaveReward < Reward::SaveOperation
  param_key :reward

  permit_columns title, cost

  before_save do
    validate_required title, message: "Donnez un nom à la récompense."
    validate_required cost, message: "Donnez un prix en XP."
    validate_numeric cost, at_least: 1, message: "Le prix doit être d'au moins 1 XP."
  end
end
