require "../../spec_helper"

describe "Cancelling an occurrence" do
  it "lets a parent cancel and restore one occurrence" do
    dad = UserFactory.create
    activity = activity_record("Danse", [child])
    wednesday = next_monday.shift(days: 2)

    AppClient.new.exec(Occurrences::Cancel.with(activity.id, wednesday.to_s("%F")), backdoor_user_id: dad.id)
    AgendaBoard.schedule.between(wednesday, wednesday.shift(days: 1)).first.cancelled.should be_true

    AppClient.new.exec(Occurrences::Restore.with(activity.id, wednesday.to_s("%F")), backdoor_user_id: dad.id)
    AgendaBoard.schedule.between(wednesday, wednesday.shift(days: 1)).first.cancelled.should be_false
  end

  it "does not exist for a guest" do
    activity = activity_record("Danse", [child])

    AppClient.new.exec(Occurrences::Cancel.with(activity.id, next_monday.shift(days: 2).to_s("%F")), backdoor_user_id: guest.id).status_code.should eq(404)
  end
end
