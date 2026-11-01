class Rewards::Shelf < BaseComponent
  needs rewards : Array(Reward)
  needs wallet : Progression::Wallet
  needs words : Lexicon

  def render
    section class: "card quests" do
      h2 "Ton solde : #{words.points(wallet.balance)}"
      if rewards.empty?
        para "Pas encore de récompense : demande à un parent d'en ajouter.", class: "empty"
      else
        ul do
          rewards.each { |reward| item(reward) }
        end
      end
    end
  end

  private def item(reward : Reward)
    li class: "quest" do
      div class: "quest-title" do
        strong reward.title
        span words.points(reward.cost), class: "quest-state"
      end
      if wallet.can_afford?(reward.cost)
        form_for Purchases::Create.with(reward.id) do
          submit "Acheter", flow_id: "buy-#{reward.id}"
        end
      else
        span "encore #{words.points(reward.cost - wallet.balance)}", class: "quest-state"
      end
    end
  end
end
