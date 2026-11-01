# A parent puts a step back to "à faire", with every step after it.
class RaidSteps::Reset < BrowserAction
  include Auth::RequireFamilyManager
  include RaidStepLookup

  post "/etapes/:raid_step_id/reinitialiser" do
    target = due_step(raid_step_id)
    step_ids = target.view.progress.steps_from(target.step).map(&.id)
    RaidCheckQuery.new.raid_step_id.in(step_ids).period_start(target.view.period_start).delete
    flash.info = "« #{target.step.title} » et la suite sont de nouveau à faire."
    redirect Home::Index
  end
end
