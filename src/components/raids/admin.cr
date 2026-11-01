# The parents' raid settings, on the Quêtes page.
class Raids::Admin < BaseComponent
  needs rows : Array(QuestBoard::RaidRow)
  needs members : Array(User)

  def render
    h2 "Raids", class: "section-title"
    rows.each { |row| mount Raids::AdminRaid, row: row, members: members }
    new_raid_form
  end

  private def new_raid_form
    operation = SaveRaid.new
    section class: "card" do
      h2 "Nouveau raid"
      form_for Raids::Create do
        mount Shared::Field, attribute: operation.title, label_text: "Titre", &.text_input(flow_id: "raid-title")
        mount Quests::RecurrenceFields, frequency: operation.frequency, days: operation.days, id_prefix: "raid"
        mount Shared::Field, attribute: operation.xp, label_text: "XP pour chaque participant", &.number_input(min: "1", max: "1000")
        submit "Créer le raid", flow_id: "add-raid"
      end
    end
  end
end
