require "../spec_helper"

private def dish(name, tag = Meals::MainTag::Pasta) : Meals::Dish
  Meals::Dish.new(name: name, tag: tag)
end

describe Meals::Dish do
  it "ignores case, accents, spaces and a final plural" do
    dish("Lasagnes  bolognaise ").same_dish?(dish("lasagne bolognaise")).should be_true
    dish("Lasagnes  Bolognaise ").key.should eq("lasagne bolognaise")
    dish("Gratin de pâtes").same_dish?(dish("GRATIN DE PATE")).should be_true
    dish("Choux-fleurs").key.should eq("choux-fleur")
    dish("Poireaux").key.should eq("poireau")
  end

  it "keeps short words and different dishes apart" do
    dish("Riz").key.should eq("riz")
    dish("Os").key.should eq("os")
    dish("Lasagnes").same_dish?(dish("Lasagnes au saumon")).should be_false
  end

  it "keeps stable stored values for the tags" do
    Meals::MainTag.values.map(&.value).should eq((0..12).to_a)
    Meals::MainTag.values.map(&.to_s).should eq(%w[Pasta Rice Potatoes Legumes Fish Poultry Beef Pork Lamb Eggs PizzaTart Vegetarian Other])
  end
end
