require "../spec_helper"

describe Appearance::Skin do
  it "keeps stable stored values, never reusing Galaxie's 2" do
    Appearance::Skin.values.map { |skin| {skin.to_s, skin.value} }.should eq([
      {"Classic", 0}, {"System", 1}, {"Animals", 3}, {"Dance", 4},
    ])
  end

  it "says which skins are always dark" do
    Appearance::Skin::Classic.always_dark?.should be_false
    Appearance::Skin::System.always_dark?.should be_true
    Appearance::Skin::Animals.always_dark?.should be_false
    Appearance::Skin::Dance.always_dark?.should be_true
  end

  it "says which skins follow the device's light / dark mode" do
    Appearance::Skin.values.select(&.follows_device?).should eq([Appearance::Skin::Classic])
  end
end
