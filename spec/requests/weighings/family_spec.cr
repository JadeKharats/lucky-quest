require "../../spec_helper"

# Product rule: no weight log for the children nor the guests.
describe "Weight log for the rest of the family" do
  it "does not exist for a child or a guest" do
    [child, guest].each do |member|
      AppClient.new.exec(Weighings::Index, backdoor_user_id: member.id).status_code.should eq(404)
      AppClient.new.exec(Weighings::Create, backdoor_user_id: member.id,
        weighing: {weight: "40", measured_at_local: SaveWeighing.now_local}).status_code.should eq(404)
    end
    WeighingQuery.new.select_count.should eq(0)
  end
end
