class RaidSteps::Update < BrowserAction
  include Auth::RequireFamilyManager

  patch "/etapes/:raid_step_id" do
    SaveRaidStep.update(RaidStepQuery.find(raid_step_id), params) do |operation, step|
      if operation.saved?
        flash.success = "Étape « #{step.title} » mise à jour."
      else
        flash.failure = operation.errors.values.flatten.first? || "Rien n'a changé."
      end
      redirect Quests::Index
    end
  end
end
