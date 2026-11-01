require "../../spec_helper"

describe Weighings::Create do
  it "records a weighing typed with a French decimal comma, in Paris time" do
    owner = UserFactory.create

    response = AppClient.new.exec(Weighings::Create,
      backdoor_user_id: owner.id,
      weighing: {weight: "72,4", measured_at_local: "2026-11-01T08:30"})

    response.status_code.should eq(302)
    response.headers["Location"].should eq(Weighings::Index.path)
    weighing = WeighingQuery.new.user_id(owner.id).first
    weighing.kilograms.should eq(72.4)
    weighing.measured_at.should eq(Time.local(2026, 11, 1, 8, 30, location: Household::TIME_ZONE))
  end

  it "belongs to the signed-in account, whatever the params say" do
    owner = UserFactory.create
    someone_else = UserFactory.create

    AppClient.new.exec(Weighings::Create,
      backdoor_user_id: owner.id,
      weighing: {weight: "72,4", measured_at_local: "2026-11-01T08:30", user_id: someone_else.id})

    WeighingQuery.new.user_id(owner.id).select_count.should eq(1)
    WeighingQuery.new.user_id(someone_else.id).select_count.should eq(0)
  end

  it "refuses an unreadable weight with a French message" do
    owner = UserFactory.create

    response = AppClient.new.exec(Weighings::Create,
      backdoor_user_id: owner.id,
      weighing: {weight: "beaucoup", measured_at_local: "2026-11-01T08:30"})

    response.status_code.should eq(422)
    response.body.should contain("entre 20 et 300 kg")
    WeighingQuery.new.select_count.should eq(0)
  end

  it "refuses a missing or unreadable date" do
    owner = UserFactory.create

    response = AppClient.new.exec(Weighings::Create,
      backdoor_user_id: owner.id,
      weighing: {weight: "72,4", measured_at_local: "hier"})

    response.status_code.should eq(422)
    response.body.should contain("date et heure")
    WeighingQuery.new.select_count.should eq(0)
  end
end
