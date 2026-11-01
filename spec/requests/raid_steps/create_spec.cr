require "../../spec_helper"

describe RaidSteps::Create do
  it "adds a step at the end with its participants" do
    parent = UserFactory.create
    raid = RaidFactory.create
    lina, emma = child("Lina"), child("Emma")
    raid_step(raid, 1, "Ranger", [lina])

    response = AppClient.new.exec(RaidSteps::Create.with(raid.id), backdoor_user_id: parent.id,
      raid_step: {title: "Aspirateur", rule: "Anyone", participant_ids: [lina.id.to_s, emma.id.to_s]})

    response.status_code.should eq(302)
    step = RaidStepQuery.new.title("Aspirateur").first
    step.position.should eq(2)
    step.rule.should eq(Quests::StepRule::Anyone)
    RaidStepParticipantQuery.new.raid_step_id(step.id).map(&.user_id).sort!.should eq([lina.id, emma.id].sort)
  end

  it "needs at least one participant, and never a guest" do
    parent = UserFactory.create
    raid = RaidFactory.create

    AppClient.new.exec(RaidSteps::Create.with(raid.id), backdoor_user_id: parent.id,
      raid_step: {title: "Ranger", rule: "Everyone"})
    AppClient.new.exec(RaidSteps::Create.with(raid.id), backdoor_user_id: parent.id,
      raid_step: {title: "Ranger", rule: "Everyone", participant_ids: [guest.id.to_s]})

    RaidStepQuery.new.select_count.should eq(0)
  end

  it "does not exist for a child" do
    lina = child

    response = AppClient.new.exec(RaidSteps::Create.with(RaidFactory.create.id), backdoor_user_id: lina.id,
      raid_step: {title: "Rien", rule: "Everyone", participant_ids: [lina.id.to_s]})

    response.status_code.should eq(404)
    RaidStepQuery.new.select_count.should eq(0)
  end
end
