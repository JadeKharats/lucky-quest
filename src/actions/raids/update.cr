class Raids::Update < BrowserAction
  include Auth::RequireFamilyManager

  patch "/raids/:raid_id" do
    SaveRaid.update(RaidQuery.active.find(raid_id), params) do |operation, raid|
      if operation.saved?
        flash.success = "Raid « #{raid.title} » mis à jour."
      else
        flash.failure = operation.errors.values.flatten.first? || "Rien n'a changé."
      end
      redirect Quests::Index
    end
  end
end
