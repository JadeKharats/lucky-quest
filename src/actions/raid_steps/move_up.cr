class RaidSteps::MoveUp < BrowserAction
  include Auth::RequireFamilyManager

  post "/etapes/:raid_step_id/monter" do
    step = RaidStepQuery.find(raid_step_id)
    above = RaidStepQuery.new.raid_id(step.raid_id).position.lt(step.position).position.desc_order.first?
    if above
      RaidStep::SaveOperation.update!(above, position: step.position)
      RaidStep::SaveOperation.update!(step, position: above.position)
    end
    redirect Quests::Index
  end
end
