require "../spec_helper"

describe "Raid flow", tags: "flow" do
  it "goes through Le Sol step by step until it is finished" do
    floor = the_floor_raid
    flow = BaseFlow.new

    flow.visit Home::Index, as: floor.lina
    flow.click "@raid-done-#{floor.tidy.id}"
    flow.should have_element(".raid-step-open", text: "en attente de Emma")

    flow.visit Home::Index, as: floor.emma
    flow.click "@raid-done-#{floor.tidy.id}"
    flow.should have_element("@flash", text: "c'est noté")

    flow.visit Home::Index, as: floor.mum
    flow.click "@raid-done-#{floor.robot.id}"
    flow.should have_element("@flash", text: "c'est noté")

    flow.visit Home::Index, as: floor.dad
    flow.click "@raid-done-#{floor.mop.id}"

    flow.should have_element(".raid-finished", text: "Raid terminé")
  end
end
