require "../spec_helper"

# 2026-11-09 is a Monday.
describe Meals::CanteenWeek do
  primary = [Time::DayOfWeek::Monday, Time::DayOfWeek::Tuesday, Time::DayOfWeek::Thursday, Time::DayOfWeek::Friday]
  week = Meals::CanteenWeek.new(primary, paris(2026, 11, 11, 15))

  it "starts on the Monday of the given day's week" do
    week.monday.should eq(paris(2026, 11, 9, 0))
  end

  it "lists the canteen days of the week" do
    week.days.should eq([paris(2026, 11, 9, 0), paris(2026, 11, 10, 0), paris(2026, 11, 12, 0), paris(2026, 11, 13, 0)])
  end

  it "is complete once every canteen day has a dish" do
    week.complete?(week.days).should be_true
    week.complete?(week.days[0..2]).should be_false
  end

  it "is never complete without canteen days" do
    empty = Meals::CanteenWeek.new([] of Time::DayOfWeek, paris(2026, 11, 11))
    empty.complete?([] of Time).should be_false
  end

  it "reads the days from the stored mask" do
    Meals::CanteenWeek.days_of(0b0011011).should eq(primary)
    Meals::CanteenWeek.days_of(0).should be_empty
  end
end
