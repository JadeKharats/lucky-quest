require "../spec_helper"

describe "Skins flow", tags: "flow" do
  it "lets a daughter switch to Animaux from the menu" do
    lina = child("Lina")
    flow = BaseFlow.new

    flow.visit Home::Index, as: lina
    flow.click "@tab-more"
    flow.click "@skin-animals"
    flow.should have_element(".skin-current", text: "Animaux ✓")

    flow.click "@tab-home"
    flow.should have_element("h1", text: "Miaou, Lina !")
  end
end
