require "../spec_helper"

describe Progression::Rank do
  it "starts at E and climbs at 150, 500, 1200, 2500 and 5000 XP" do
    {
      0 => Progression::Rank::E, 149 => Progression::Rank::E,
      150 => Progression::Rank::D, 499 => Progression::Rank::D,
      500 => Progression::Rank::C, 1199 => Progression::Rank::C,
      1200 => Progression::Rank::B, 2499 => Progression::Rank::B,
      2500 => Progression::Rank::A, 4999 => Progression::Rank::A,
      5000 => Progression::Rank::S, 99_999 => Progression::Rank::S,
    }.each do |points, rank|
      Progression::Rank.for(points).should eq(rank)
    end
  end

  it "knows its threshold and the next rank" do
    Progression::Rank::C.threshold.should eq(500)
    Progression::Rank::C.next_rank.should eq(Progression::Rank::B)
    Progression::Rank::S.next_rank.should be_nil
  end
end

describe Progression::Standing do
  it "tells how far the member is from the next rank" do
    standing = Progression::Standing.new(xp: 300)

    standing.rank.should eq(Progression::Rank::D)
    standing.next_rank.should eq(Progression::Rank::C)
    standing.xp_to_next.should eq(200)
    standing.progress.should eq(0.43)
  end

  it "is full at the top rank" do
    standing = Progression::Standing.new(xp: 6000)

    standing.next_rank.should be_nil
    standing.xp_to_next.should eq(0)
    standing.progress.should eq(1.0)
  end

  it "is empty at the start of a rank" do
    Progression::Standing.new(xp: 150).progress.should eq(0.0)
  end
end
