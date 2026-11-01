require "../spec_helper"

describe "Agenda flow", tags: "flow" do
  it "lets a grandparent take an open trip and see it on her home" do
    activity = activity_record("Danse", [child("Lina")], starts_on: today_in_paris.at_beginning_of_day)
    mamie = guest
    today = today_in_paris.to_s("%F")
    flow = BaseFlow.new

    flow.visit Schedules::Index, as: mamie
    flow.click "@take-#{activity.id}-#{today}-aller"
    flow.should have_element("@flash", text: "Merci ! Tu fais l'aller")

    flow.visit Home::Index, as: mamie
    flow.should have_element(".quests", text: "Danse")
  end
end
