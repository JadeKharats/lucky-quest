class Quests::NewForm < BaseComponent
  needs operation : CreateQuest
  needs members : Array(User)

  def render
    section class: "card" do
      h2 "Nouvelle quête"
      form_for Quests::Create do
        mount Shared::Field, attribute: operation.title, label_text: "Titre", &.text_input(flow_id: "quest-title")
        member_field
        mount Quests::RecurrenceFields, frequency: operation.frequency, days: operation.days, id_prefix: "quest"
        mount Shared::Field, attribute: operation.xp, label_text: "XP", &.number_input(min: "1", max: "1000")
        mount Quests::CanteenMenuField, attribute: operation.canteen_menu, id: "quest_canteen_menu"
        submit "Ajouter", flow_id: "add-quest"
      end
    end
  end

  private def member_field
    label "Pour", for: "quest_user_id"
    select_input operation.user_id, id: "quest_user_id" do
      options_for_select operation.user_id, members.map { |member| {member.name, member.id} }
    end
    mount Shared::FieldErrors, operation.user_id
  end
end
