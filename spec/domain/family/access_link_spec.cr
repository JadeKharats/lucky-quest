require "../spec_helper"

describe Family::AccessLink do
  issued = paris(2026, 11, 1, 10)

  it "is valid for 48 hours" do
    Family::AccessLink::LIFETIME.should eq(48.hours)
    Family::AccessLink.issued_at(issued).expires_at.should eq(paris(2026, 11, 3, 10))
  end

  it "can be used before it expires" do
    link = Family::AccessLink.issued_at(issued)
    link.usable?(issued).should be_true
    link.usable?(paris(2026, 11, 3, 9, 59)).should be_true
  end

  it "cannot be used once expired" do
    link = Family::AccessLink.issued_at(issued)
    link.usable?(paris(2026, 11, 3, 10)).should be_false
  end

  it "cannot be used twice" do
    link = Family::AccessLink.new(expires_at: paris(2026, 11, 3, 10), used_at: issued)
    link.usable?(issued).should be_false
  end
end
