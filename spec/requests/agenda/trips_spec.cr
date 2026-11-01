require "../../spec_helper"

private def wednesday : String
  next_monday.shift(days: 2).to_s("%F")
end

private def resolved_drivers(activity : Activity) : Agenda::Drivers
  AgendaBoard.schedule.between(next_monday, next_monday.shift(days: 7)).find! { |found| found.activity.id == activity.id }.drivers
end

describe "Trips" do
  it "lets a guest take an open trip, and give it back" do
    mamie = guest
    activity = activity_record("Danse", [child])

    AppClient.new.exec(Trips::Take.with(activity.id, wednesday, "aller"), backdoor_user_id: mamie.id)
    resolved_drivers(activity).should eq(Agenda::Drivers.new(to: mamie.id, back: nil))

    AppClient.new.exec(Trips::Release.with(activity.id, wednesday, "aller"), backdoor_user_id: mamie.id)
    resolved_drivers(activity).should eq(Agenda::Drivers.new(to: nil, back: nil))
  end

  it "does not let someone take a trip already driven, or give back someone else's" do
    dad = UserFactory.create
    mamie = guest
    activity = activity_record("Danse", [child], driver_to: dad)

    AppClient.new.exec(Trips::Take.with(activity.id, wednesday, "aller"), backdoor_user_id: mamie.id).status_code.should eq(404)
    AppClient.new.exec(Trips::Release.with(activity.id, wednesday, "aller"), backdoor_user_id: mamie.id).status_code.should eq(404)
    resolved_drivers(activity).to.should eq(dad.id)
  end

  it "lets a parent choose any driver for one occurrence" do
    dad = UserFactory.create
    mamie = guest
    activity = activity_record("Danse", [child], driver_to: dad, driver_back: dad)

    AppClient.new.exec(Trips::Assign.with(activity.id, wednesday, "retour"), backdoor_user_id: dad.id, trip: {driver_id: mamie.id.to_s})

    resolved_drivers(activity).should eq(Agenda::Drivers.new(to: dad.id, back: mamie.id))
    activity.reload.driver_back_id.should eq(dad.id)
  end

  it "does not let a child drive or a guest assign" do
    lina = child
    mamie = guest
    activity = activity_record("Danse", [lina])

    AppClient.new.exec(Trips::Take.with(activity.id, wednesday, "aller"), backdoor_user_id: lina.id).status_code.should eq(404)
    AppClient.new.exec(Trips::Assign.with(activity.id, wednesday, "aller"), backdoor_user_id: mamie.id, trip: {driver_id: mamie.id.to_s}).status_code.should eq(404)
  end

  it "answers 404 for a day without an occurrence" do
    activity = activity_record("Danse", [child])

    AppClient.new.exec(Trips::Take.with(activity.id, next_monday.to_s("%F"), "aller"), backdoor_user_id: guest.id).status_code.should eq(404)
  end
end
