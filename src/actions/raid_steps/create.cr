class RaidSteps::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/raids/:raid_id/etapes" do
    raid = RaidQuery.active.find(raid_id)
    position = RaidStepQuery.new.raid_id(raid.id).select_count.to_i + 1
    SaveRaidStep.create(params, raid_id: raid.id, position: position) do |operation, step|
      if step
        flash.success = "Étape « #{step.title} » ajoutée."
      else
        flash.failure = operation.errors.values.flatten.first? || "Étape non ajoutée."
      end
      redirect Quests::Index
    end
  end
end
