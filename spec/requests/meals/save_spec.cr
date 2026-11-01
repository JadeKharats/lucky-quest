require "../../spec_helper"

private def plan(member, dish, tag = "Fish", slot = "diner")
  AppClient.new.exec(HomeMeals::Save.with(next_monday.to_s("%F"), slot), backdoor_user_id: member.id,
    home_meal: {dish: dish, tag: tag})
end

describe HomeMeals::Save do
  it "lets a parent or a guest plan a meal" do
    plan(UserFactory.create, "Saumon")
    plan(guest, "Omelette", "Eggs", "dejeuner")

    HomeMealQuery.new.day.asc_order.slot.asc_order.map { |meal| {meal.slot, meal.dish, meal.tag} }.should eq([
      {Meals::Slot::Lunch, "Omelette", Meals::MainTag::Eggs},
      {Meals::Slot::Dinner, "Saumon", Meals::MainTag::Fish},
    ])
  end

  it "replaces the dish of a slot, and clears it when emptied" do
    parent = UserFactory.create
    plan(parent, "Saumon")
    plan(parent, "Cabillaud")
    HomeMealQuery.new.map(&.dish).should eq(["Cabillaud"])

    plan(parent, "")

    HomeMealQuery.new.select_count.should eq(0)
  end

  it "does not exist for a child" do
    plan(child, "Frites", "Potatoes").status_code.should eq(404)
    HomeMealQuery.new.select_count.should eq(0)
  end
end
