require "../spec_helper"

PUPIL_ID  = 1_i64
FATHER_ID = 2_i64
GRANNY_ID = 3_i64

# Dance: Wednesdays 14:00–15:30 from 2026-10-07, dad drives both ways.
private def dance(last_day : Time? = nil, weekly = true, needs_ride = true) : Agenda::Activity
  Agenda::Activity.new(id: 1_i64, title: "Danse", place: "Studio", starts_on: paris(2026, 10, 7, 0),
    start_minutes: 14 * 60, end_minutes: 15 * 60 + 30, weekly: weekly, last_day: last_day,
    participant_ids: [PUPIL_ID], needs_ride: needs_ride,
    usual: Agenda::Drivers.new(to: FATHER_ID, back: FATHER_ID))
end

private def schedule(activities, changes = [] of Agenda::Change) : Agenda::Schedule
  Agenda::Schedule.new(activities, changes)
end

private def days(occurrences) : Array(Int32)
  occurrences.map(&.day.day)
end

describe Agenda::Schedule do
  november = {paris(2026, 11, 1, 0), paris(2026, 12, 1, 0)}

  it "repeats a weekly activity on its weekday within the range" do
    days(schedule([dance]).between(*november)).should eq([4, 11, 18, 25])
  end

  it "keeps Paris wall-clock times across the clock change" do
    occurrences = schedule([dance]).between(paris(2026, 10, 20, 0), paris(2026, 11, 1, 0))

    occurrences.map(&.starts_at).should eq([paris(2026, 10, 21, 14), paris(2026, 10, 28, 14)])
    occurrences.map(&.starts_at.to_utc.hour).should eq([12, 13])
    occurrences.first.ends_at.should eq(paris(2026, 10, 21, 15, 30))
  end

  it "stops after its last day, which is included" do
    days(schedule([dance(last_day: paris(2026, 11, 18, 0))]).between(*november)).should eq([4, 11, 18])
  end

  it "never starts before the start date" do
    days(schedule([dance]).between(paris(2026, 9, 1, 0), paris(2026, 10, 15, 0))).should eq([7, 14])
  end

  it "happens once when not weekly" do
    gala = dance(weekly: false)

    days(schedule([gala]).between(paris(2026, 10, 1, 0), paris(2026, 12, 1, 0))).should eq([7])
    schedule([gala]).between(*november).should be_empty
  end

  it "sorts the occurrences of several activities by start time" do
    yoga = Agenda::Activity.new(id: 2_i64, title: "Yoga", place: "Salle", starts_on: paris(2026, 11, 4, 0),
      start_minutes: 9 * 60, end_minutes: 10 * 60, weekly: false, last_day: nil,
      participant_ids: [FATHER_ID], needs_ride: false, usual: Agenda::Drivers.new(to: nil, back: nil))

    schedule([dance, yoga]).between(paris(2026, 11, 4, 0), paris(2026, 11, 5, 0)).map(&.activity.title).should eq(["Yoga", "Danse"])
  end

  describe "changes of one occurrence" do
    it "flags a cancelled occurrence" do
      cancelled = Agenda::Change.new(activity_id: 1_i64, day: paris(2026, 11, 11, 0), cancelled: true, drivers: nil)
      occurrences = schedule([dance], [cancelled]).between(*november)

      occurrences.map(&.cancelled).should eq([false, true, false, false])
    end

    it "takes the drivers of the change over the usual ones" do
      granny = Agenda::Change.new(activity_id: 1_i64, day: paris(2026, 11, 11, 0), cancelled: false,
        drivers: Agenda::Drivers.new(to: GRANNY_ID, back: nil))
      occurrences = schedule([dance], [granny]).between(*november)

      occurrences[1].drivers.should eq(Agenda::Drivers.new(to: GRANNY_ID, back: nil))
      occurrences[0].drivers.should eq(Agenda::Drivers.new(to: FATHER_ID, back: FATHER_ID))
    end

    it "ignores a change of another activity" do
      other = Agenda::Change.new(activity_id: 9_i64, day: paris(2026, 11, 11, 0), cancelled: true, drivers: nil)

      schedule([dance], [other]).between(*november).none?(&.cancelled).should be_true
    end
  end

  describe "trips" do
    it "lists the trips nobody drives, outside cancelled occurrences" do
      changes = [
        Agenda::Change.new(activity_id: 1_i64, day: paris(2026, 11, 4, 0), cancelled: false, drivers: Agenda::Drivers.new(to: nil, back: FATHER_ID)),
        Agenda::Change.new(activity_id: 1_i64, day: paris(2026, 11, 11, 0), cancelled: true, drivers: Agenda::Drivers.new(to: nil, back: nil)),
      ]

      trips = schedule([dance], changes).open_trips(paris(2026, 11, 1, 0), paris(2026, 11, 15, 0))

      trips.map { |trip| {trip.occurrence.day.day, trip.leg} }.should eq([{4, Agenda::Leg::To}])
    end

    it "has no trips when no ride is needed" do
      occurrence = schedule([dance(needs_ride: false)]).between(*november).first

      occurrence.trips.should be_empty
      occurrence.driver_ids.should be_empty
    end

    it "lists both trips with their drivers" do
      occurrence = schedule([dance]).between(*november).first

      occurrence.trips.map { |trip| {trip.leg, trip.driver_id} }.should eq([{Agenda::Leg::To, FATHER_ID}, {Agenda::Leg::Back, FATHER_ID}])
    end
  end

  describe "a member's agenda" do
    it "keeps what she attends or drives, not the cancelled ones" do
      changes = [Agenda::Change.new(activity_id: 1_i64, day: paris(2026, 11, 11, 0), cancelled: true, drivers: nil)]
      plan = schedule([dance], changes)

      days(plan.for_member(PUPIL_ID, *november)).should eq([4, 18, 25])
      days(plan.for_member(FATHER_ID, *november)).should eq([4, 18, 25])
      plan.for_member(GRANNY_ID, *november).should be_empty
    end
  end

  it "keeps stable stored values for the legs" do
    Agenda::Leg::To.value.should eq(0)
    Agenda::Leg::Back.value.should eq(1)
  end
end
