require "../../spec_helper"

describe RaidChecks::Delete do
  it "undoes her own check while the next step has not started" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)
    check_raid_step(floor.tidy, floor.emma)

    response = AppClient.new.exec(RaidChecks::Delete.with(floor.tidy.id), backdoor_user_id: floor.lina.id)

    response.status_code.should eq(302)
    RaidCheckQuery.new.map(&.user_id).should eq([floor.emma.id])
  end

  it "answers 404 once the next step has started" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)
    check_raid_step(floor.tidy, floor.emma)
    check_raid_step(floor.robot, floor.mum)

    AppClient.new.exec(RaidChecks::Delete.with(floor.tidy.id), backdoor_user_id: floor.lina.id).status_code.should eq(404)
    RaidCheckQuery.new.select_count.should eq(3)
  end
end
