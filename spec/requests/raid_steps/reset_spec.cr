require "../../spec_helper"

describe RaidSteps::Reset do
  it "resets a step and the ones after it" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)
    check_raid_step(floor.tidy, floor.emma)
    check_raid_step(floor.robot, floor.mum)

    AppClient.new.exec(RaidSteps::Reset.with(floor.robot.id), backdoor_user_id: floor.dad.id)

    RaidCheckQuery.new.map(&.raid_step_id).uniq!.should eq([floor.tidy.id])
  end

  it "does not exist for a child" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)

    AppClient.new.exec(RaidSteps::Reset.with(floor.tidy.id), backdoor_user_id: floor.lina.id).status_code.should eq(404)
    RaidCheckQuery.new.select_count.should eq(1)
  end
end
