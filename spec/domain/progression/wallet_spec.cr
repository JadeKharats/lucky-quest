require "../spec_helper"

describe Progression::Wallet do
  it "keeps what was earned minus what was spent" do
    Progression::Wallet.new(earned: 300, spent: 120).balance.should eq(180)
  end

  it "affords a reward up to the balance" do
    wallet = Progression::Wallet.new(earned: 300, spent: 120)

    wallet.can_afford?(180).should be_true
    wallet.can_afford?(181).should be_false
  end

  it "never affords a free or negative price" do
    Progression::Wallet.new(earned: 300, spent: 0).can_afford?(0).should be_false
    Progression::Wallet.new(earned: 300, spent: 0).can_afford?(-5).should be_false
  end
end
