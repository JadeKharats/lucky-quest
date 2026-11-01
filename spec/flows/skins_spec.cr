require "../spec_helper"

describe "Skins flow", tags: "flow" do
  it "lets a daughter switch her home to Galaxie" do
    lina = child("Lina")
    flow = BaseFlow.new

    flow.visit Home::Index, as: lina
    flow.click "@skin-galaxy"

    # Galaxie shows its titles in capitals.
    flow.should have_element("h1", text: "BIENVENUE À BORD, LINA.")
    flow.should have_element(".skin-current", text: "Galaxie ✓")
  end
end
