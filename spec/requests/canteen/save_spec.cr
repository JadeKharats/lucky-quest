require "../../spec_helper"

private def week_param : String
  next_monday.to_s("%F")
end

private def save_week(member, dishes, tags = dishes.map { "Pasta" })
  AppClient.new.exec(Canteen::Save.with(week_param), backdoor_user_id: member.id,
    canteen_week: {dishes: dishes, tags: tags})
end

describe Canteen::Save do
  it "stores her school's lunch for each canteen day" do
    parc = school
    lina = pupil("Lina", parc)

    response = save_week(lina, ["Lasagnes", "", "Poisson pané", "", ""], ["Pasta", "Other", "Fish", "Other", "Other"])

    response.headers["Location"].should eq(Canteen::Index.with(semaine: week_param).path)
    CanteenMealQuery.new.school_id(parc.id).day.asc_order.map { |meal| {meal.day, meal.dish, meal.tag} }.should eq([
      {next_monday, "Lasagnes", Meals::MainTag::Pasta},
      {next_monday.shift(days: 2), "Poisson pané", Meals::MainTag::Fish},
    ])
  end

  it "removes a dish that is emptied" do
    lina = pupil("Lina", school)
    save_week(lina, ["Lasagnes", "", "", "", ""])

    save_week(lina, ["", "", "", "", ""])

    CanteenMealQuery.new.select_count.should eq(0)
  end

  it "marks her canteen quest done once next week is complete" do
    lina = pupil("Lina", school)
    canteen = QuestFactory.create &.user_id(lina.id).title("Menu de la cantine").frequency(Quests::Frequency::Weekly).canteen_menu(true)
    other = QuestFactory.create &.user_id(lina.id).frequency(Quests::Frequency::Weekly)

    save_week(lina, ["A", "B", "C", "D", ""])
    CompletionQuery.new.select_count.should eq(0)

    save_week(lina, ["A", "B", "C", "D", "E"])

    completion = CompletionQuery.new.first
    completion.quest_id.should eq(canteen.id)
    completion.validated_at.should be_nil
    CompletionQuery.new.quest_id(other.id).first?.should be_nil
  end

  it "does not exist for a parent" do
    AppClient.new.exec(Canteen::Save.with(week_param), backdoor_user_id: UserFactory.create.id,
      canteen_week: {dishes: ["A"], tags: ["Pasta"]}).status_code.should eq(404)
  end
end
