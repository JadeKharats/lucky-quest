require "../spec_helper"

describe Family::Role do
  it "keeps stable stored values" do
    Family::Role::Parent.value.should eq(0)
    Family::Role::Child.value.should eq(1)
    Family::Role::Guest.value.should eq(2)
  end

  it "lets only parents manage the family" do
    Family::Role::Parent.manage_family?.should be_true
    Family::Role::Child.manage_family?.should be_false
    Family::Role::Guest.manage_family?.should be_false
  end

  it "gives a weight log to parents only" do
    Family::Role::Parent.keep_weight_log?.should be_true
    Family::Role::Child.keep_weight_log?.should be_false
    Family::Role::Guest.keep_weight_log?.should be_false
  end

  it "gives quests to parents and children" do
    Family::Role::Parent.keep_quests?.should be_true
    Family::Role::Child.keep_quests?.should be_true
    Family::Role::Guest.keep_quests?.should be_false
  end

  it "lets parents and guests validate quests" do
    Family::Role::Parent.validate_quests?.should be_true
    Family::Role::Guest.validate_quests?.should be_true
    Family::Role::Child.validate_quests?.should be_false
  end

  it "lets only children buy rewards" do
    Family::Role::Child.buy_rewards?.should be_true
    Family::Role::Parent.buy_rewards?.should be_false
    Family::Role::Guest.buy_rewards?.should be_false
  end

  it "lets parents and guests plan the meals" do
    Family::Role::Parent.plan_meals?.should be_true
    Family::Role::Guest.plan_meals?.should be_true
    Family::Role::Child.plan_meals?.should be_false
  end

  it "lets only children enter their canteen menu" do
    Family::Role::Child.enter_canteen_menu?.should be_true
    Family::Role::Parent.enter_canteen_menu?.should be_false
    Family::Role::Guest.enter_canteen_menu?.should be_false
  end

  it "limits only guests in time" do
    Family::Role::Guest.time_limited?.should be_true
    Family::Role::Parent.time_limited?.should be_false
    Family::Role::Child.time_limited?.should be_false
  end
end
