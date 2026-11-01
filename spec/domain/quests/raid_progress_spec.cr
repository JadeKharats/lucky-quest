require "../spec_helper"

LINA  = 1_i64
EMMA  = 2_i64
DAD   = 3_i64
OTHER = 4_i64

private def step(id, participants, rule = Quests::StepRule::Everyone) : Quests::RaidStep
  Quests::RaidStep.new(id: id.to_i64, title: "Étape #{id}", participant_ids: participants, rule: rule)
end

private def check(step_id, member_id) : Quests::RaidCheck
  Quests::RaidCheck.new(step_id: step_id.to_i64, member_id: member_id)
end

# "Le Sol": both daughters tidy, a parent starts the robot, the father mops.
private def the_floor : Quests::Raid
  Quests::Raid.new(id: 1_i64, title: "Le Sol", recurrence: Quests::Recurrence.weekly, steps: [
    step(10, [LINA, EMMA]),
    step(20, [DAD, OTHER], Quests::StepRule::Anyone),
    step(30, [DAD]),
  ])
end

private def progress(checks = [] of Quests::RaidCheck) : Quests::RaidProgress
  Quests::RaidProgress.new(the_floor, checks)
end

private def states(progress) : Array(Quests::StepState)
  the_floor.steps.map { |raid_step| progress.state(raid_step) }
end

describe Quests::RaidProgress do
  it "opens the first step and locks the others" do
    states(progress).should eq([Quests::StepState::Open, Quests::StepState::Locked, Quests::StepState::Locked])
    progress.finished?.should be_false
  end

  describe "a step where everyone does her part" do
    it "stays open until every participant has checked, and says who is awaited" do
      half = progress([check(10, LINA)])

      states(half).first.should eq(Quests::StepState::Open)
      half.checked_by(the_floor.steps[0]).should eq([LINA])
      half.awaited(the_floor.steps[0]).should eq([EMMA])
    end

    it "is done once all have checked, which opens the next one" do
      done = progress([check(10, EMMA), check(10, LINA)])

      states(done).should eq([Quests::StepState::Done, Quests::StepState::Open, Quests::StepState::Locked])
      done.checked_by(the_floor.steps[0]).should eq([LINA, EMMA])
      done.awaited(the_floor.steps[0]).should be_empty
      done.finished?.should be_false
    end
  end

  describe "a step where one is enough" do
    it "is done as soon as any participant has checked" do
      robot = progress([check(10, LINA), check(10, EMMA), check(20, OTHER)])

      states(robot).should eq([Quests::StepState::Done, Quests::StepState::Done, Quests::StepState::Open])
      robot.awaited(the_floor.steps[1]).should be_empty
    end

    it "awaits all of its participants while nobody has checked" do
      progress.awaited(the_floor.steps[1]).should eq([DAD, OTHER])
    end
  end

  it "keeps a step locked while an earlier one is not done, whatever its checks" do
    stray = progress([check(10, LINA), check(20, DAD)])

    states(stray).should eq([Quests::StepState::Open, Quests::StepState::Locked, Quests::StepState::Locked])
  end

  it "is finished when every step is done" do
    all = progress([check(10, LINA), check(10, EMMA), check(20, DAD), check(30, DAD)])

    states(all).should eq([Quests::StepState::Done, Quests::StepState::Done, Quests::StepState::Done])
    all.finished?.should be_true
  end

  it "never counts a step without participants as done" do
    lonely = Quests::Raid.new(id: 3_i64, title: "Seul", recurrence: Quests::Recurrence.weekly, steps: [step(40, [] of Int64)])

    Quests::RaidProgress.new(lonely, [] of Quests::RaidCheck).finished?.should be_false
  end

  it "is never finished without steps" do
    empty = Quests::Raid.new(id: 2_i64, title: "Vide", recurrence: Quests::Recurrence.weekly, steps: [] of Quests::RaidStep)

    Quests::RaidProgress.new(empty, [] of Quests::RaidCheck).finished?.should be_false
  end

  describe "#can_check?" do
    it "lets a participant check her part of the open step once" do
      progress.can_check?(LINA, the_floor.steps[0]).should be_true
      progress([check(10, LINA)]).can_check?(LINA, the_floor.steps[0]).should be_false
    end

    it "refuses someone who is not a participant" do
      progress.can_check?(DAD, the_floor.steps[0]).should be_false
    end

    it "refuses a locked or done step" do
      progress.can_check?(DAD, the_floor.steps[2]).should be_false
      robot = progress([check(10, LINA), check(10, EMMA), check(20, OTHER)])
      robot.can_check?(DAD, the_floor.steps[1]).should be_false
    end
  end

  describe "#can_undo?" do
    it "lets a member undo her own check while the next step has not started" do
      done = progress([check(10, LINA), check(10, EMMA)])

      done.can_undo?(LINA, the_floor.steps[0]).should be_true
      done.can_undo?(DAD, the_floor.steps[0]).should be_false
    end

    it "refuses once someone checked the next step" do
      started = progress([check(10, LINA), check(10, EMMA), check(20, DAD)])

      started.can_undo?(LINA, the_floor.steps[0]).should be_false
      started.can_undo?(DAD, the_floor.steps[1]).should be_true
    end

    it "allows undoing the last step" do
      all = progress([check(10, LINA), check(10, EMMA), check(20, DAD), check(30, DAD)])

      all.can_undo?(DAD, the_floor.steps[2]).should be_true
    end
  end

  it "lists a step and the ones after it, for a parent's reset" do
    progress.steps_from(the_floor.steps[1]).map(&.id).should eq([20, 30])
  end

  it "keeps stable stored values for the step rules" do
    Quests::StepRule::Everyone.value.should eq(0)
    Quests::StepRule::Anyone.value.should eq(1)
  end
end
