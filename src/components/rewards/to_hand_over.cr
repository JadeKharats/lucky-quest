class Rewards::ToHandOver < BaseComponent
  needs purchases : Array(Purchase)

  def render
    section class: "card quests" do
      h2 "À remettre"
      if purchases.empty?
        para "Aucun achat en attente.", class: "empty"
      else
        ul do
          purchases.each { |purchase| item(purchase) }
        end
      end
    end
  end

  private def item(purchase : Purchase)
    li class: "quest" do
      div class: "quest-title" do
        strong purchase.reward.title
        span "#{purchase.user.name} · #{purchase.cost} XP · #{French.date(purchase.bought_at.in(Household::TIME_ZONE))}", class: "quest-state"
      end
      div class: "member-actions" do
        form_for Purchases::Hand.with(purchase.id) do
          submit "Remis", flow_id: "hand-#{purchase.id}"
        end
        form_for Purchases::Delete.with(purchase.id), class: "secondary" do
          submit "Annuler"
        end
      end
    end
  end
end
