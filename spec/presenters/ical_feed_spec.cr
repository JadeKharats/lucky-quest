require "../spec_helper"

private def occurrence(cancelled = false, drivers = Agenda::Drivers.new(to: 2_i64, back: nil)) : Agenda::Occurrence
  activity = Agenda::Activity.new(id: 7_i64, title: "Danse, jazz", place: "Studio; salle 2",
    starts_on: Time.local(2026, 11, 11, location: Household::TIME_ZONE), start_minutes: 14 * 60, end_minutes: 15 * 60 + 30,
    weekly: true, last_day: nil, participant_ids: [1_i64], needs_ride: true, usual: drivers)
  Agenda::Schedule.new([activity], [] of Agenda::Change)
    .between(activity.starts_on, activity.starts_on.shift(days: 1)).first
    .copy_with(cancelled: cancelled)
end

private def feed(member_id, occurrences = [occurrence]) : String
  IcalFeed.new(occurrences, member_id: member_id, member_name: "Lina",
    names: {1_i64 => "Lina", 2_i64 => "David"}, now: Time.utc(2026, 11, 1, 12)).to_s
end

describe IcalFeed do
  it "is a calendar with CRLF line endings" do
    text = feed(1_i64)

    text.should start_with("BEGIN:VCALENDAR\r\nVERSION:2.0\r\n")
    text.should end_with("END:VCALENDAR\r\n")
    text.should contain("X-WR-CALNAME:Quest — Lina\r\n")
  end

  it "lists an activity the member takes part in, in UTC, with escaped text" do
    text = feed(1_i64)

    text.should contain("UID:activity-7-20261111@quest.yoteau.fr\r\n")
    text.should contain("DTSTART:20261111T130000Z\r\n")
    text.should contain("DTEND:20261111T143000Z\r\n")
    text.should contain("SUMMARY:Danse\\, jazz\r\n")
    text.should contain("LOCATION:Studio; salle 2\r\n")
    text.should contain("DTSTAMP:20261101T120000Z\r\n")
  end

  it "lists the trips the member drives, 30 minutes around the activity" do
    text = feed(2_i64)

    text.should contain("UID:activity-7-20261111-aller@quest.yoteau.fr\r\n")
    text.should contain("SUMMARY:Conduire Lina — Danse\\, jazz (aller)\r\n")
    text.should contain("DTSTART:20261111T123000Z\r\nDTEND:20261111T130000Z\r\n")
    text.should_not contain("UID:activity-7-20261111@")
    text.should_not contain("retour")
  end

  it "leaves out cancelled occurrences and other people's" do
    feed(1_i64, [occurrence(cancelled: true)]).should_not contain("BEGIN:VEVENT")
    feed(3_i64).should_not contain("BEGIN:VEVENT")
  end

  it "folds lines longer than 75 bytes" do
    line = IcalFeed.fold("SUMMARY:" + "é" * 50)

    line.split("\r\n").all? { |part| part.bytesize <= 75 }.should be_true
    line.split("\r\n")[1].should start_with(" ")
    line.gsub("\r\n ", "").should eq("SUMMARY:" + "é" * 50)
  end
end
