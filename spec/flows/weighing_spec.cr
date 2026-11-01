require "../spec_helper"

describe "Weighing flow", tags: "flow" do
  it "records a weighing typed the French way and shows it" do
    flow = BaseFlow.new
    flow.visit Weighings::Index, as: UserFactory.create

    flow.fill "weighing:weight", with: "72,4"
    flow.click "@save-weighing"

    flow.should have_element("@flash", text: "Pesée enregistrée.")
    flow.should have_element(".recent-weight", text: "72,4 kg")
    flow.should have_element(".stat-value", text: "72,4 kg")
  end
end
