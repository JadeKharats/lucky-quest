require "../../spec_helper"

describe "The raid on the home page" do
  it "shows everyone the steps and who is awaited" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)

    [floor.lina, floor.emma, floor.dad, guest].each do |member|
      body = AppClient.new.exec(Home::Index, backdoor_user_id: member.id).body
      body.should contain("Le Sol")
      body.should contain("en attente de Emma")
      body.should contain("Serpillère")
    end
  end

  it "offers the button only to a participant who has not checked yet" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)

    AppClient.new.exec(Home::Index, backdoor_user_id: floor.emma.id).body.should contain(RaidChecks::Create.with(floor.tidy.id).path)
    AppClient.new.exec(Home::Index, backdoor_user_id: floor.dad.id).body.should_not contain(RaidChecks::Create.with(floor.tidy.id).path)
  end

  it "says when the raid is finished" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)
    check_raid_step(floor.tidy, floor.emma)
    check_raid_step(floor.robot, floor.mum)
    check_raid_step(floor.mop, floor.dad)

    AppClient.new.exec(Home::Index, backdoor_user_id: floor.lina.id).body.should contain("Raid terminé")
  end
end
