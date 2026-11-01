require "../../spec_helper"

describe Schedules::Index do
  it "shows everyone the week's activities with participants and drivers" do
    lina = child("Lina")
    dad = UserFactory.create &.name("David")
    activity_record("Danse", [lina], driver_to: dad)

    [dad, lina, guest].each do |member|
      body = AppClient.new.exec(Schedules::Index.with(semaine: next_monday.to_s("%F")), backdoor_user_id: member.id).body
      body.should contain("Danse")
      body.should contain("Aller : David")
      body.should contain("Retour : <span class=\"meal-warning\">⚠️ Qui conduit ?</span>")
    end
  end

  it "lists the activities for a parent, with their weekday in Paris" do
    dad = UserFactory.create
    activity_record("Danse", [child])

    AppClient.new.exec(Schedules::Index, backdoor_user_id: dad.id).body.should contain("chaque mer. 14:00–15:30")
  end
end
