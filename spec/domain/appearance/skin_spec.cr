require "../spec_helper"

describe Appearance::Skin do
  it "keeps stable stored values" do
    Appearance::Skin.values.map { |skin| {skin.to_s, skin.value} }.should eq([
      {"Classic", 0}, {"System", 1}, {"Galaxy", 2},
    ])
  end

  it "says which skins are always dark" do
    Appearance::Skin::Classic.always_dark?.should be_false
    Appearance::Skin::System.always_dark?.should be_true
    Appearance::Skin::Galaxy.always_dark?.should be_true
  end
end
