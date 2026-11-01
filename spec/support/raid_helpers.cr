# "Le Sol", due every day: the daughters tidy (each her part), a parent starts
# the robot (one is enough), the father mops.
record FloorRaid, raid : Raid, tidy : RaidStep, robot : RaidStep, mop : RaidStep,
  lina : User, emma : User, dad : User, mum : User

def the_floor_raid : FloorRaid
  lina, emma = child("Lina"), child("Emma")
  dad = UserFactory.create &.name("David")
  mum = UserFactory.create &.name("Maman")
  raid = RaidFactory.create
  tidy = raid_step(raid, 1, "Ranger", [lina, emma])
  robot = raid_step(raid, 2, "Aspirateur robot", [dad, mum], Quests::StepRule::Anyone)
  mop = raid_step(raid, 3, "Serpillère", [dad])
  FloorRaid.new(raid, tidy, robot, mop, lina, emma, dad, mum)
end

def raid_step(raid : Raid, position : Int32, title : String, members : Array(User), rule = Quests::StepRule::Everyone) : RaidStep
  step = RaidStepFactory.create &.raid_id(raid.id).position(position).title(title).rule(rule)
  members.each do |member|
    RaidStepParticipant::SaveOperation.create!(raid_step_id: step.id, user_id: member.id)
  end
  step
end

def check_raid_step(step : RaidStep, member : User) : RaidCheck
  RaidCheck::SaveOperation.create!(raid_step_id: step.id, user_id: member.id,
    period_start: today_in_paris.at_beginning_of_day, checked_at: Time.utc)
end
