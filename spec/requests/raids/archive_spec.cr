require "../../spec_helper"

describe Raids::Archive do
  it "takes the raid off everyone's home" do
    floor = the_floor_raid

    AppClient.new.exec(Raids::Archive.with(floor.raid.id), backdoor_user_id: floor.dad.id)

    floor.raid.reload.archived_at.should_not be_nil
    AppClient.new.exec(Home::Index, backdoor_user_id: floor.lina.id).body.should_not contain("Le Sol")
  end

  it "does not exist for a child" do
    floor = the_floor_raid

    AppClient.new.exec(Raids::Archive.with(floor.raid.id), backdoor_user_id: floor.lina.id).status_code.should eq(404)
    floor.raid.reload.archived_at.should be_nil
  end
end
