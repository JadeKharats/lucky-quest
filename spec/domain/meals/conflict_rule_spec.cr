require "../spec_helper"

LINA_ID = 1_i64
EMMA_ID = 2_i64

private def lunch(child, day, name, tag = Meals::MainTag::Pasta) : Meals::CanteenLunch
  Meals::CanteenLunch.new(child_id: child, day: paris(2026, 11, day, 0), dish: Meals::Dish.new(name: name, tag: tag))
end

private def home(day, slot, name, tag = Meals::MainTag::Pasta) : Meals::HomeMeal
  Meals::HomeMeal.new(day: paris(2026, 11, day, 0), slot: slot, dish: Meals::Dish.new(name: name, tag: tag))
end

DINNER = Meals::Slot::Dinner
LUNCH  = Meals::Slot::Lunch

# Tuesday 2026-11-10: Lina has lasagne at the canteen.
describe Meals::ConflictRule do
  rule = Meals::ConflictRule.new([lunch(LINA_ID, 10, "Lasagnes")])

  it "blocks the same dish at dinner the same day" do
    conflict = rule.worst(home(10, DINNER, "lasagne"))

    conflict.try(&.severity).should eq(Meals::Severity::Blocking)
    conflict.try(&.same_day).should be_true
    conflict.try(&.lunch.child_id).should eq(LINA_ID)
  end

  it "warns about the same main tag at dinner the same day" do
    rule.worst(home(10, DINNER, "Spaghetti")).try(&.severity).should eq(Meals::Severity::Warning)
  end

  it "warns about the same dish or tag at dinner the evening before" do
    before = rule.worst(home(9, DINNER, "Lasagnes"))
    before.try(&.severity).should eq(Meals::Severity::Warning)
    before.try(&.same_day).should be_false
    rule.worst(home(9, DINNER, "Penne")).try(&.severity).should eq(Meals::Severity::Warning)
  end

  it "says nothing about other tags, other days, or lunches at home" do
    rule.worst(home(10, DINNER, "Saumon", Meals::MainTag::Fish)).should be_nil
    rule.worst(home(11, DINNER, "Lasagnes")).should be_nil
    rule.worst(home(8, DINNER, "Lasagnes")).should be_nil
    rule.worst(home(10, LUNCH, "Lasagnes")).should be_nil
  end

  it "never matches on the tag 'autre'" do
    other = Meals::ConflictRule.new([lunch(LINA_ID, 10, "Couscous", Meals::MainTag::Other)])

    other.worst(home(10, DINNER, "Tajine", Meals::MainTag::Other)).should be_nil
    other.worst(home(10, DINNER, "couscous", Meals::MainTag::Other)).try(&.severity).should eq(Meals::Severity::Blocking)
  end

  it "keeps stable stored values for the slots" do
    Meals::Slot::Lunch.value.should eq(0)
    Meals::Slot::Dinner.value.should eq(1)
  end

  it "checks every daughter and keeps the worst first" do
    both = Meals::ConflictRule.new([
      lunch(EMMA_ID, 10, "Penne"),
      lunch(LINA_ID, 10, "Lasagnes"),
    ])

    both.conflicts(home(10, DINNER, "Lasagnes")).map { |found| {found.lunch.child_id, found.severity} }.should eq([
      {LINA_ID, Meals::Severity::Blocking},
      {EMMA_ID, Meals::Severity::Warning},
    ])
  end
end
