require "spec"
require "../../src/presenters/french"

describe French do
  it "writes kilograms with a decimal comma" do
    French.kilograms(72.4).should eq("72,4 kg")
    French.kilograms(72.0).should eq("72,0 kg")
    French.kilograms(72.36).should eq("72,4 kg")
  end

  it "writes a signed delta with a real minus sign" do
    French.delta(-0.4).should eq("−0,4 kg")
    French.delta(0.3).should eq("+0,3 kg")
    French.delta(0.0).should eq("0,0 kg")
  end

  it "writes a short date and time with French month names" do
    French.date_time(Time.local(2026, 11, 1, 8, 5)).should eq("1 nov. à 08:05")
    French.date_time(Time.local(2026, 8, 15, 21, 30)).should eq("15 août à 21:30")
  end

  it "writes a short date" do
    French.date(Time.local(2026, 2, 3)).should eq("3 févr.")
  end
end
