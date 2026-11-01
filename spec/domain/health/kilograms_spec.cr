require "../spec_helper"

describe Health::Kilograms do
  describe ".new" do
    it "rounds to one decimal" do
      Health::Kilograms.new(72.46).value.should eq(72.5)
      Health::Kilograms.new(72.44).value.should eq(72.4)
    end

    it "accepts the bounds of a human weight" do
      Health::Kilograms.new(20.0).value.should eq(20.0)
      Health::Kilograms.new(300.0).value.should eq(300.0)
    end

    it "checks the bounds after rounding" do
      Health::Kilograms.new(19.96).value.should eq(20.0)
      Health::Kilograms.new(300.04).value.should eq(300.0)
    end

    it "rejects a value outside the bounds" do
      expect_raises(ArgumentError, "between 20 and 300") { Health::Kilograms.new(19.9) }
      expect_raises(ArgumentError, "between 20 and 300") { Health::Kilograms.new(300.1) }
    end
  end

  describe ".parse?" do
    it "reads a French decimal comma" do
      Health::Kilograms.parse?("72,4").try(&.value).should eq(72.4)
    end

    it "reads a decimal point" do
      Health::Kilograms.parse?("72.4").try(&.value).should eq(72.4)
    end

    it "reads a whole number and ignores surrounding spaces" do
      Health::Kilograms.parse?(" 72 ").try(&.value).should eq(72.0)
    end

    it "returns nil for anything that is not a plain number" do
      ["", "abc", "72kg", "-72", "+72", "7e1", "72,", ",4", "72,4,1"].each do |input|
        Health::Kilograms.parse?(input).should be_nil
      end
    end

    it "returns nil for a number outside the bounds" do
      Health::Kilograms.parse?("12").should be_nil
      Health::Kilograms.parse?("301").should be_nil
    end

    it "checks the bounds on the value rounded to 100 g" do
      Health::Kilograms.parse?("19,96").try(&.value).should eq(20.0)
      Health::Kilograms.parse?("19,94").should be_nil
    end
  end

  it "prints one decimal" do
    Health::Kilograms.new(72.0).to_s.should eq("72.0")
  end

  it "compares by value" do
    Health::Kilograms.new(72.0).should eq(Health::Kilograms.new(72.0))
    Health::Kilograms.new(71.9).should be < Health::Kilograms.new(72.0)
  end
end
