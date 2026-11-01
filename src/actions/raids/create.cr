class Raids::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/raids" do
    SaveRaid.create(params) do |operation, raid|
      if raid
        flash.success = "Raid « #{raid.title} » créé : ajoute-lui ses étapes."
      else
        flash.failure = operation.errors.values.flatten.first? || "Raid non créé."
      end
      redirect Quests::Index
    end
  end
end
