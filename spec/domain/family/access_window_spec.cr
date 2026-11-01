require "../spec_helper"

describe Family::AccessWindow do
  describe ".through" do
    window = Family::AccessWindow.through(paris(2026, 12, 31, 15))

    it "stays open the whole last day, Paris time" do
      window.open?(paris(2026, 12, 31, 0)).should be_true
      window.open?(paris(2026, 12, 31, 23, 59)).should be_true
    end

    it "closes at midnight after the last day" do
      window.open?(paris(2027, 1, 1, 0)).should be_false
      window.open?(paris(2027, 1, 5)).should be_false
    end

    it "remembers the last day" do
      window.last_day.should eq(paris(2026, 12, 31, 0))
    end

    it "ends at the start of the next day, even across a clock change" do
      autumn = Family::AccessWindow.through(paris(2026, 10, 24))
      autumn.ends_at.should eq(paris(2026, 10, 25, 0))
      Family::AccessWindow.through(paris(2026, 10, 25)).ends_at.should eq(paris(2026, 10, 26, 0))
    end
  end

  describe ".unlimited" do
    it "is always open and has no last day" do
      window = Family::AccessWindow.unlimited
      window.open?(paris(2099, 1, 1)).should be_true
      window.last_day.should be_nil
    end
  end
end
