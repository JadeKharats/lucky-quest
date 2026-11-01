class RaidChecks::Create < BrowserAction
  include RaidStepLookup

  post "/etapes/:raid_step_id/fait" do
    target = due_step(raid_step_id)
    raise Lucky::RouteNotFoundError.new(context) unless target.view.progress.can_check?(current_user.id, target.step)

    RaidCheck::SaveOperation.create!(raid_step_id: target.record.id, user_id: current_user.id,
      period_start: target.view.period_start, checked_at: Time.utc)
    XpLedger.sync_raid(target.record.raid_id)
    flash.success = "« #{target.step.title} » : c'est noté !"
    redirect Home::Index
  end
end
