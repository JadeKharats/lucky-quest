class Rewards::MyPurchases < BaseComponent
  needs purchases : Array(Purchase)

  def render
    return if purchases.empty?

    section class: "card quests" do
      h2 "Tes achats"
      ul do
        purchases.each do |purchase|
          li class: "quest" do
            span purchase.reward.title, class: "quest-title"
            span purchase.handed_at ? "remise ✓" : "à remettre", class: "quest-state"
          end
        end
      end
    end
  end
end
