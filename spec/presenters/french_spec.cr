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

  it "describes a recurrence" do
    French.recurrence(Quests::Recurrence.daily).should eq("Tous les jours")
    French.recurrence(Quests::Recurrence.weekly).should eq("Une fois par semaine")
    days = [Time::DayOfWeek::Friday, Time::DayOfWeek::Monday]
    French.recurrence(Quests::Recurrence.on(days)).should eq("lun., ven.")
  end

  it "names the period of an occurrence" do
    French.period(Time.local(2026, 11, 4), weekly: false).should eq("4 nov.")
    French.period(Time.local(2026, 11, 2), weekly: true).should eq("semaine du 2 nov.")
  end

  it "names the step rules" do
    French.step_rule(Quests::StepRule::Everyone).should eq("Chacun sa part")
    French.step_rule(Quests::StepRule::Anyone).should eq("Un seul suffit")
  end

  it "lists names the French way" do
    French.names([] of String).should eq("")
    French.names(["Lina"]).should eq("Lina")
    French.names(["Lina", "Emma"]).should eq("Lina et Emma")
    French.names(["Lina", "Emma", "David"]).should eq("Lina, Emma et David")
  end

  it "names the main tags and the days" do
    French.tag(Meals::MainTag::Fish).should eq("poisson")
    French.tag(Meals::MainTag::PizzaTart).should eq("pizza / tarte")
    French.weekday_date(Time.local(2026, 11, 9)).should eq("lun. 9 nov.")
  end

  it "names each role" do
    French.role(Family::Role::Parent).should eq("Parent")
    French.role(Family::Role::Child).should eq("Enfant")
    French.role(Family::Role::Guest).should eq("Invité·e")
  end
end
