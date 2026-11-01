require "../spec_helper"

describe "Quests flow", tags: "flow" do
  it "lets a child complete her quest and a guest validate it" do
    lina = child("Lina")
    quest = QuestFactory.create &.user_id(lina.id).title("Mettre la table")
    flow = BaseFlow.new

    flow.visit Home::Index, as: lina
    flow.click "@done-#{quest.id}"
    flow.should have_element(".quest-state", text: "faite, à valider")

    flow.visit Home::Index, as: guest
    flow.click "@to-validate"
    completion = CompletionQuery.new.first
    flow.click "@validate-#{completion.id}"
    flow.should have_element("@flash", text: "« Mettre la table » validée pour Lina.")

    flow.visit Home::Index, as: lina
    flow.should have_element(".quest-state", text: "validée ✓")
  end
end
