require "../../spec_helper"

describe RaidChecks::Create do
  it "checks a participant's part of the open step for today" do
    floor = the_floor_raid

    response = AppClient.new.exec(RaidChecks::Create.with(floor.tidy.id), backdoor_user_id: floor.lina.id)

    response.headers["Location"].should eq(Home::Index.path)
    check = RaidCheckQuery.new.first
    check.user_id.should eq(floor.lina.id)
    check.period_start.should eq(today_in_paris.at_beginning_of_day)
  end

  it "answers 404 for a locked step, a step one is not part of, or a second check" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)

    [
      {floor.robot, floor.dad}, # locked: Emma has not tidied yet
      {floor.tidy, floor.dad},  # not a participant
      {floor.tidy, floor.lina}, # already checked
    ].each do |step, member|
      AppClient.new.exec(RaidChecks::Create.with(step.id), backdoor_user_id: member.id).status_code.should eq(404)
    end
    RaidCheckQuery.new.select_count.should eq(1)
  end

  it "answers 404 when the raid is archived or not due today" do
    floor = the_floor_raid
    mask = Quests::Recurrence.on(Time::DayOfWeek.values.reject(today_in_paris.day_of_week)).mask
    Raid::SaveOperation.update!(floor.raid, frequency: Quests::Frequency::Weekdays, days_mask: mask)

    AppClient.new.exec(RaidChecks::Create.with(floor.tidy.id), backdoor_user_id: floor.lina.id).status_code.should eq(404)

    Raid::SaveOperation.update!(floor.raid.reload, frequency: Quests::Frequency::Daily, days_mask: 0, archived_at: Time.utc)
    AppClient.new.exec(RaidChecks::Create.with(floor.tidy.id), backdoor_user_id: floor.lina.id).status_code.should eq(404)
    RaidCheckQuery.new.select_count.should eq(0)
  end
end
