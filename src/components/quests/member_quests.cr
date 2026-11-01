class Quests::MemberQuests < BaseComponent
  needs row : QuestBoard::Row

  def render
    section class: "card quests" do
      h2 row.member.name
      if row.quests.empty?
        para "Aucune quête.", class: "empty"
      else
        ul do
          row.quests.each { |quest| quest_item(quest) }
        end
      end
    end
  end

  private def quest_item(quest : ::Quest)
    li class: "quest" do
      div class: "quest-title" do
        strong quest.title
        span French.recurrence(quest.recurrence), class: "quest-state"
      end
      details class: "member-edit" do
        summary "Modifier"
        operation = UpdateQuest.form_for(quest)
        form_for Quests::Update.with(quest.id) do
          mount Shared::Field, attribute: operation.title, label_text: "Titre", &.text_input
          mount Quests::RecurrenceFields, frequency: operation.frequency, days: operation.days, id_prefix: "quest_#{quest.id}"
          submit "Enregistrer"
        end
        form_for Quests::Archive.with(quest.id), class: "secondary" do
          submit "Archiver"
        end
      end
    end
  end
end
