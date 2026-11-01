require "../spec_helper"

describe Quests::Status do
  it "is validated at once when a parent completes their own quest" do
    Quests::Status.after_completion_by(Family::Role::Parent).should eq(Quests::Status::Validated)
  end

  it "waits for a validation when a child completes hers" do
    Quests::Status.after_completion_by(Family::Role::Child).should eq(Quests::Status::Done)
  end

  it "comes from what was stored" do
    Quests::Status.of(nil).should eq(Quests::Status::ToDo)
    Quests::Status.of(Quests::Completion.new(quest_id: 1, period_start: paris(2026, 11, 2, 0), validated: false)).should eq(Quests::Status::Done)
    Quests::Status.of(Quests::Completion.new(quest_id: 1, period_start: paris(2026, 11, 2, 0), validated: true)).should eq(Quests::Status::Validated)
  end
end
