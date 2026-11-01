require "../../spec_helper"

describe "Ordering raid steps" do
  it "moves a step up" do
    floor = the_floor_raid

    AppClient.new.exec(RaidSteps::MoveUp.with(floor.mop.id), backdoor_user_id: floor.dad.id)

    RaidStepQuery.new.raid_id(floor.raid.id).position.asc_order.map(&.title).should eq(["Ranger", "Serpillère", "Aspirateur robot"])
  end

  it "deletes a step and closes the gap" do
    floor = the_floor_raid
    check_raid_step(floor.robot, floor.dad)

    AppClient.new.exec(RaidSteps::Delete.with(floor.robot.id), backdoor_user_id: floor.dad.id)

    RaidStepQuery.new.raid_id(floor.raid.id).position.asc_order.map { |step| {step.title, step.position} }.should eq([{"Ranger", 1}, {"Serpillère", 2}])
    RaidCheckQuery.new.select_count.should eq(0)
  end

  it "does not exist for a child" do
    floor = the_floor_raid

    AppClient.new.exec(RaidSteps::MoveUp.with(floor.mop.id), backdoor_user_id: floor.lina.id).status_code.should eq(404)
    AppClient.new.exec(RaidSteps::Delete.with(floor.mop.id), backdoor_user_id: floor.lina.id).status_code.should eq(404)
    RaidStepQuery.new.select_count.should eq(3)
  end
end
