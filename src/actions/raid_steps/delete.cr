# Its participants and checks go with it; the steps after it move up.
class RaidSteps::Delete < BrowserAction
  include Auth::RequireFamilyManager

  delete "/etapes/:raid_step_id" do
    step = RaidStepQuery.find(raid_step_id)
    RaidStep::DeleteOperation.delete!(step)
    RaidStepQuery.of([step.raid_id]).to_a.each_with_index(1) do |other, position|
      RaidStep::SaveOperation.update!(other, position: position) unless other.position == position
    end
    XpLedger.sync_raid(step.raid_id)
    flash.success = "Étape « #{step.title} » supprimée."
    redirect Quests::Index
  end
end
