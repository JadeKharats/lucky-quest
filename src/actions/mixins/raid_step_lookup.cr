# The step a member acts on, in its raid of today; 404 if the raid is
# archived or not due today.
module RaidStepLookup
  record Target, view : RaidBoard::View, step : Quests::RaidStep, record : RaidStep

  private def due_step(raid_step_id : String) : Target
    record = RaidStepQuery.find(raid_step_id)
    view = RaidBoard.for_step(record) || raise Lucky::RouteNotFoundError.new(context)
    step = view.raid.steps.find! { |candidate| candidate.id == record.id }
    Target.new(view, step, record)
  end
end
