require "../../spec_helper"

describe "Managing activities" do
  it "lets a parent add a weekly activity with its participants and usual drivers" do
    dad = UserFactory.create
    lina = child

    response = AppClient.new.exec(Activities::Create, backdoor_user_id: dad.id, activity: {
      title: "Danse", place: "Studio", start_date: "2026-11-11", last_date: "2027-06-30",
      start_time: "14:00", end_time: "15:30", weekly: "true", needs_ride: "true",
      participant_ids: [lina.id.to_s], driver_to_id: dad.id.to_s, driver_back_id: "",
    })

    response.status_code.should eq(302)
    activity = ActivityQuery.new.first
    {activity.start_minutes, activity.end_minutes, activity.weekly, activity.driver_to_id, activity.driver_back_id}.should eq({840, 930, true, dad.id, nil})
    activity.starts_on.should eq(Time.local(2026, 11, 11, location: Household::TIME_ZONE))
    activity.last_day.should eq(Time.local(2027, 6, 30, location: Household::TIME_ZONE))
    ActivityParticipantQuery.new.map(&.user_id).should eq([lina.id])
  end

  it "refuses an end before the start, or a child as a driver" do
    dad = UserFactory.create
    lina = child

    AppClient.new.exec(Activities::Create, backdoor_user_id: dad.id, activity: {
      title: "Danse", place: "", start_date: "2026-11-11", start_time: "15:00", end_time: "14:00",
      weekly: "true", needs_ride: "false", participant_ids: [lina.id.to_s],
    })
    AppClient.new.exec(Activities::Create, backdoor_user_id: dad.id, activity: {
      title: "Danse", place: "", start_date: "2026-11-11", start_time: "14:00", end_time: "15:00",
      weekly: "true", needs_ride: "true", participant_ids: [lina.id.to_s], driver_to_id: lina.id.to_s,
    })

    ActivityQuery.new.select_count.should eq(0)
  end

  it "ends an activity from today" do
    dad = UserFactory.create
    activity = activity_record("Danse", starts_on: today_in_paris.at_beginning_of_day.shift(days: -14))

    AppClient.new.exec(Activities::End.with(activity.id), backdoor_user_id: dad.id)

    activity.reload.last_day.should eq(today_in_paris.at_beginning_of_day.shift(days: -1))
  end

  it "does not exist for a child or a guest" do
    [child, guest].each do |member|
      AppClient.new.exec(Activities::Create, backdoor_user_id: member.id, activity: {
        title: "Rien", place: "", start_date: "2026-11-11", start_time: "14:00", end_time: "15:00",
        weekly: "false", needs_ride: "false",
      }).status_code.should eq(404)
    end
    ActivityQuery.new.select_count.should eq(0)
  end
end
