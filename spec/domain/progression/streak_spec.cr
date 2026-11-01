require "../spec_helper"

private def days(*numbers) : Array(Time)
  numbers.map { |day| paris(2026, 11, day, 0) }.to_a
end

# Today is Friday 2026-11-13.
describe Progression::Streak do
  today = paris(2026, 11, 13, 18)

  it "counts the days in a row with a due quest done, today included" do
    Progression::Streak.new(due: days(10, 11, 12, 13), done: days(11, 12, 13), today: today).length.should eq(3)
  end

  it "keeps yesterday's streak while today is not done yet" do
    Progression::Streak.new(due: days(11, 12, 13), done: days(11, 12), today: today).length.should eq(2)
  end

  it "stops at the last due day that was missed" do
    Progression::Streak.new(due: days(9, 10, 11, 12), done: days(9, 11, 12), today: today).length.should eq(2)
  end

  it "skips days without any quest due" do
    # Nothing due on the weekend of the 7th and 8th.
    Progression::Streak.new(due: days(5, 6, 9, 10), done: days(5, 6, 9, 10), today: paris(2026, 11, 10, 20)).length.should eq(4)
  end

  it "is zero when nothing was done" do
    Progression::Streak.new(due: days(12, 13), done: [] of Time, today: today).length.should eq(0)
    Progression::Streak.new(due: [] of Time, done: [] of Time, today: today).length.should eq(0)
  end

  it "ignores days after today" do
    Progression::Streak.new(due: days(12, 14), done: days(12, 14), today: today).length.should eq(1)
  end
end
