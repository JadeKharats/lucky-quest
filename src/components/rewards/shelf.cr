# The shop of a daughter: her balance, then each reward with its price. A
# reward out of reach shows how far she is, not a disabled button.
class Rewards::Shelf < BaseComponent
  needs rewards : Array(Reward)
  needs wallet : Progression::Wallet
  needs words : Lexicon

  def render
    section class: "card hero balance" do
      h2 "Ton solde : #{words.points(wallet.balance)}", class: "balance-amount"
    end
    if rewards.empty?
      section class: "card" do
        para "Pas encore de récompense : demande à un parent d'en ajouter.", class: "empty"
      end
    else
      ul class: "reward-grid" do
        rewards.each_with_index { |reward, index| item(reward, index) }
      end
    end
  end

  private def item(reward : Reward, index : Int32)
    li class: "reward" do
      span class: "reward-tile quest-tile-#{index % Quests::OccurrenceRow::TINTS}", "aria-hidden": "true" do
        mount Shared::Icon, name: :shop, size: 36
      end
      strong reward.title, class: "reward-title"
      if wallet.can_afford?(reward.cost)
        span words.points(reward.cost), class: "quest-state"
        form_for Purchases::Create.with(reward.id) do
          submit "Acheter", flow_id: "buy-#{reward.id}"
        end
      else
        out_of_reach(reward)
      end
    end
  end

  private def out_of_reach(reward : Reward)
    missing = reward.cost - wallet.balance
    div class: "bar", role: "img", "aria-label": "#{words.points(wallet.balance)} sur #{words.points(reward.cost)}" do
      div class: "bar-fill", style: "width: #{reward.cost.positive? ? (wallet.balance * 100 // reward.cost).clamp(0, 100) : 0}%"
    end
    span "#{words.points(reward.cost)} · encore #{words.points(missing)}", class: "quest-state"
  end
end
