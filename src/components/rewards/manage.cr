class Rewards::Manage < BaseComponent
  needs rewards : Array(Reward)
  needs operation : SaveReward

  def render
    section class: "card quests" do
      h2 "Récompenses"
      ul do
        rewards.each do |reward|
          li class: "quest" do
            div class: "quest-title" do
              strong reward.title
              span "#{reward.cost} XP", class: "quest-state"
            end
            form_for Rewards::Archive.with(reward.id), class: "secondary" do
              submit "Retirer"
            end
          end
        end
      end
      form_for Rewards::Create do
        mount Shared::Field, attribute: operation.title, label_text: "Récompense", &.text_input(flow_id: "reward-title")
        mount Shared::Field, attribute: operation.cost, label_text: "Prix (XP)", &.number_input(min: "1", flow_id: "reward-cost")
        submit "Ajouter", flow_id: "add-reward"
      end
    end
  end
end
