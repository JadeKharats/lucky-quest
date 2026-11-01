# A member takes back her own check, while the next step has not started.
class RaidChecks::Delete < BrowserAction
  include RaidStepLookup

  delete "/etapes/:raid_step_id/fait" do
    target = due_step(raid_step_id)
    raise Lucky::RouteNotFoundError.new(context) unless target.view.progress.can_undo?(current_user.id, target.step)

    RaidCheckQuery.new.raid_step_id(target.record.id).user_id(current_user.id).period_start(target.view.period_start).delete
    flash.info = "« #{target.step.title} » est de nouveau à faire."
    redirect Home::Index
  end
end
