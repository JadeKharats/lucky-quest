require "../../spec_helper"

describe RaidSteps::Update do
  it "changes the title, the rule and the participants" do
    floor = the_floor_raid

    AppClient.new.exec(RaidSteps::Update.with(floor.tidy.id), backdoor_user_id: floor.dad.id,
      raid_step: {title: "Tout ranger", rule: "Anyone", participant_ids: [floor.emma.id.to_s]})

    step = floor.tidy.reload
    step.title.should eq("Tout ranger")
    step.rule.should eq(Quests::StepRule::Anyone)
    RaidStepParticipantQuery.new.raid_step_id(step.id).map(&.user_id).should eq([floor.emma.id])
  end

  it "does not exist for a child" do
    floor = the_floor_raid

    AppClient.new.exec(RaidSteps::Update.with(floor.tidy.id), backdoor_user_id: floor.lina.id,
      raid_step: {title: "Rien", rule: "Anyone", participant_ids: [floor.lina.id.to_s]}).status_code.should eq(404)
    floor.tidy.reload.title.should eq("Ranger")
  end
end
