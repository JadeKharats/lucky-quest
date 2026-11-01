require "../spec_helper"

private def quest(id, title, recurrence) : Quests::Quest
  Quests::Quest.new(id: id.to_i64, title: title, recurrence: recurrence)
end

private def done(quest_id, period_start, validated = false) : Quests::Completion
  Quests::Completion.new(quest_id: quest_id.to_i64, period_start: period_start, validated: validated)
end

# 2026-11-04 is a Wednesday.
describe Quests::Agenda do
  table = quest(1, "Mettre la table", Quests::Recurrence.daily)
  cooking = quest(2, "Aider en cuisine", Quests::Recurrence.on([Time::DayOfWeek::Monday]))
  dishwasher = quest(3, "Lave-vaisselle", Quests::Recurrence.daily)
  canteen = quest(4, "Menu de la cantine", Quests::Recurrence.weekly)
  quests = [table, cooking, dishwasher, canteen]
  wednesday = paris(2026, 11, 4, 17)

  it "lists today's daily quests due today, by title" do
    agenda = Quests::Agenda.new(quests, [] of Quests::Completion, wednesday)

    agenda.today.map(&.quest.title).should eq(["Lave-vaisselle", "Mettre la table"])
    agenda.today.map(&.status).uniq!.should eq([Quests::Status::ToDo])
    agenda.today.first.period_start.should eq(paris(2026, 11, 4, 0))
  end

  it "lists the weekly quests for this week" do
    agenda = Quests::Agenda.new(quests, [] of Quests::Completion, wednesday)

    agenda.this_week.map(&.quest.title).should eq(["Menu de la cantine"])
    agenda.this_week.first.period_start.should eq(paris(2026, 11, 2, 0))
  end

  it "shows what is already done or validated in the current period" do
    completions = [
      done(1, paris(2026, 11, 4, 0)),
      done(3, paris(2026, 11, 3, 0), validated: true), # yesterday's: not today's
      done(4, paris(2026, 11, 2, 0), validated: true),
    ]
    agenda = Quests::Agenda.new(quests, completions, wednesday)

    agenda.today.map { |occurrence| {occurrence.quest.title, occurrence.status} }.should eq([
      {"Lave-vaisselle", Quests::Status::ToDo},
      {"Mettre la table", Quests::Status::Done},
    ])
    agenda.this_week.first.status.should eq(Quests::Status::Validated)
  end

  it "breaks title ties by id, so the order never moves" do
    twins = [quest(9, "Ranger", Quests::Recurrence.daily), quest(5, "Ranger", Quests::Recurrence.daily)]

    Quests::Agenda.new(twins, [] of Quests::Completion, wednesday).today.map(&.quest.id).should eq([5, 9])
  end

  it "finds the occurrence of one quest" do
    agenda = Quests::Agenda.new(quests, [done(4, paris(2026, 11, 2, 0))], wednesday)

    agenda.occurrence_of(4).try(&.status).should eq(Quests::Status::Done)
    agenda.occurrence_of(2).should be_nil # not due on Wednesday
  end
end
