require "../spec_helper"

describe "Progression flow", tags: "flow" do
  it "turns a validated quest into XP that buys a reward" do
    lina = child("Lina")
    parent = UserFactory.create
    quest = QuestFactory.create &.user_id(lina.id).title("Mettre la table").xp(100)
    reward = RewardFactory.create &.title("Choisir le film").cost(80)
    flow = BaseFlow.new

    flow.visit Home::Index, as: lina
    flow.click "@done-#{quest.id}"
    flow.should have_element("@flash", text: "est faite")

    flow.visit Validations::Index, as: parent
    flow.click "@validate-#{CompletionQuery.new.first.id}"
    flow.should have_element("@flash", text: "validée pour Lina")

    flow.visit Home::Index, as: lina
    flow.should have_element(".progress-xp", text: "100 XP")
    flow.visit Rewards::Index, as: lina
    flow.click "@buy-#{reward.id}"
    flow.should have_element("@flash", text: "achetée")

    flow.visit Rewards::Index, as: parent
    flow.click "@hand-#{PurchaseQuery.new.first.id}"
    flow.should have_element("@flash", text: "remise à Lina")
  end
end
