require "../spec_helper"

# 2026-11-02 is a Monday.
describe Quests::Recurrence do
  describe ".daily" do
    it "is due every day, one occurrence per day" do
      recurrence = Quests::Recurrence.daily
      (2..8).each { |day| recurrence.due_on?(paris(2026, 11, day)).should be_true }
      recurrence.period_start(paris(2026, 11, 4, 18)).should eq(paris(2026, 11, 4, 0))
      recurrence.weekly?.should be_false
    end
  end

  describe ".on" do
    recurrence = Quests::Recurrence.on([Time::DayOfWeek::Monday, Time::DayOfWeek::Friday])

    it "is due on its days only" do
      recurrence.due_on?(paris(2026, 11, 2)).should be_true
      recurrence.due_on?(paris(2026, 11, 3)).should be_false
      recurrence.due_on?(paris(2026, 11, 6)).should be_true
      recurrence.due_on?(paris(2026, 11, 8)).should be_false
    end

    it "has one occurrence per day" do
      recurrence.period_start(paris(2026, 11, 6, 18)).should eq(paris(2026, 11, 6, 0))
      recurrence.weekly?.should be_false
    end

    it "needs at least one day" do
      expect_raises(ArgumentError, "at least one day") { Quests::Recurrence.on([] of Time::DayOfWeek) }
    end

    it "keeps its days" do
      recurrence.days.should eq(Set{Time::DayOfWeek::Monday, Time::DayOfWeek::Friday})
    end
  end

  describe ".weekly" do
    recurrence = Quests::Recurrence.weekly

    it "is due any day, one occurrence per week starting on Monday" do
      recurrence.due_on?(paris(2026, 11, 5)).should be_true
      recurrence.period_start(paris(2026, 11, 2, 9)).should eq(paris(2026, 11, 2, 0))
      recurrence.period_start(paris(2026, 11, 8, 23)).should eq(paris(2026, 11, 2, 0))
      recurrence.period_start(paris(2026, 11, 9)).should eq(paris(2026, 11, 9, 0))
      recurrence.weekly?.should be_true
    end
  end

  describe "stored form" do
    it "packs the days into a bit mask and back" do
      days = [Time::DayOfWeek::Monday, Time::DayOfWeek::Wednesday, Time::DayOfWeek::Sunday]
      recurrence = Quests::Recurrence.on(days)

      recurrence.mask.should eq(0b1000101)
      Quests::Recurrence.load(Quests::Frequency::Weekdays, 0b1000101).should eq(recurrence)
    end

    it "loads the other frequencies" do
      Quests::Recurrence.load(Quests::Frequency::Daily, 0).should eq(Quests::Recurrence.daily)
      Quests::Recurrence.load(Quests::Frequency::Weekly, 0).should eq(Quests::Recurrence.weekly)
      Quests::Recurrence.daily.mask.should eq(0)
      Quests::Recurrence.daily.should_not eq(Quests::Recurrence.weekly)
    end

    it "keeps stable stored values" do
      Quests::Frequency::Daily.value.should eq(0)
      Quests::Frequency::Weekdays.value.should eq(1)
      Quests::Frequency::Weekly.value.should eq(2)
    end
  end
end
