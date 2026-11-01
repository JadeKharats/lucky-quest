require "../../spec_helper"

describe "Earning XP" do
  it "gives a child the quest's XP once a guest validates it" do
    lina = child
    quest = QuestFactory.create &.user_id(lina.id).title("Mettre la table").xp(15)
    AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: lina.id)
    xp_of(lina).should eq(0)

    AppClient.new.exec(Validations::Create.with(CompletionQuery.new.first.id), backdoor_user_id: guest.id)

    xp_of(lina).should eq(15)
    XpEntryQuery.new.first.label.should eq("Mettre la table")
  end

  it "gives a parent the XP of their own quest at once" do
    parent = UserFactory.create
    quest = QuestFactory.create &.user_id(parent.id).title("30 min de marche")

    AppClient.new.exec(Completions::Create.with(quest.id), backdoor_user_id: parent.id)

    xp_of(parent).should eq(10)
  end

  it "gives every participant the raid's XP when it is finished, and takes it back if it is not anymore" do
    floor = the_floor_raid
    Raid::SaveOperation.update!(floor.raid, xp: 40)
    check_raid_step(floor.tidy, floor.lina)
    check_raid_step(floor.tidy, floor.emma)
    check_raid_step(floor.robot, floor.mum)

    AppClient.new.exec(RaidChecks::Create.with(floor.mop.id), backdoor_user_id: floor.dad.id)

    [floor.lina, floor.emma, floor.mum, floor.dad].map { |member| xp_of(member) }.should eq([40, 40, 40, 40])

    AppClient.new.exec(RaidChecks::Delete.with(floor.mop.id), backdoor_user_id: floor.dad.id)

    XpEntryQuery.new.select_count.should eq(0)
  end

  it "takes the raid's XP back when a parent resets a step" do
    floor = the_floor_raid
    check_raid_step(floor.tidy, floor.lina)
    check_raid_step(floor.tidy, floor.emma)
    check_raid_step(floor.robot, floor.mum)
    AppClient.new.exec(RaidChecks::Create.with(floor.mop.id), backdoor_user_id: floor.dad.id)
    xp_of(floor.lina).should eq(30)

    AppClient.new.exec(RaidSteps::Reset.with(floor.robot.id), backdoor_user_id: floor.dad.id)

    xp_of(floor.lina).should eq(0)
  end
end
