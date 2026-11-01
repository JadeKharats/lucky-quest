class Raids::AdminRaid < BaseComponent
  needs row : QuestBoard::RaidRow
  needs members : Array(User)

  def render
    raid = row.raid
    section class: "card quests" do
      h2 raid.title
      para "#{French.recurrence(raid.recurrence)} · #{raid.xp} XP pour chacun", class: "quest-state"
      ol class: "raid-steps" do
        row.steps.each { |step| step_item(step) }
      end
      new_step_form
      raid_settings
    end
  end

  private def step_item(step : RaidStep)
    li class: "quest" do
      div class: "quest-title" do
        strong step.title
        span "#{French.step_rule(step.rule)} · #{participant_names(step)}", class: "quest-state"
      end
      details class: "member-edit" do
        summary "Modifier"
        operation = SaveRaidStep.form_for(step)
        form_for RaidSteps::Update.with(step.id) do
          step_fields(operation, "raid_step_#{step.id}")
          submit "Enregistrer"
        end
        div class: "member-actions" do
          form_for RaidSteps::MoveUp.with(step.id), class: "secondary" do
            submit "Monter"
          end
          form_for RaidSteps::Delete.with(step.id), class: "secondary" do
            submit "Supprimer l'étape"
          end
        end
      end
    end
  end

  private def new_step_form
    details class: "member-edit" do
      summary "Ajouter une étape"
      form_for RaidSteps::Create.with(row.raid.id) do
        step_fields(SaveRaidStep.new, "raid_#{row.raid.id}_new_step")
        submit "Ajouter l'étape", flow_id: "add-step-#{row.raid.id}"
      end
    end
  end

  private def raid_settings
    operation = SaveRaid.form_for(row.raid)
    details class: "member-edit" do
      summary "Modifier le raid"
      form_for Raids::Update.with(row.raid.id) do
        mount Shared::Field, attribute: operation.title, label_text: "Titre", &.text_input
        mount Quests::RecurrenceFields, frequency: operation.frequency, days: operation.days, id_prefix: "raid_#{row.raid.id}"
        mount Shared::Field, attribute: operation.xp, label_text: "XP pour chaque participant", &.number_input(min: "1", max: "1000")
        submit "Enregistrer"
      end
      form_for Raids::Archive.with(row.raid.id), class: "secondary" do
        submit "Archiver le raid"
      end
    end
  end

  private def step_fields(operation : SaveRaidStep, id_prefix : String)
    mount Shared::Field, attribute: operation.title, label_text: "Étape", &.text_input(flow_id: "#{id_prefix}_title")
    label "Règle", for: "#{id_prefix}_rule"
    select_input operation.rule, id: "#{id_prefix}_rule" do
      options_for_select operation.rule, Quests::StepRule.values.map { |rule| {French.step_rule(rule), rule} }
    end
    participant_fields(operation)
  end

  private def participant_fields(operation : SaveRaidStep)
    chosen = operation.participant_ids.value || [] of Int64
    fieldset class: "days" do
      legend "Participants"
      members.each do |member|
        label class: "day" do
          if chosen.includes?(member.id)
            input type: "checkbox", name: "raid_step:participant_ids[]", value: member.id.to_s, checked: "checked"
          else
            input type: "checkbox", name: "raid_step:participant_ids[]", value: member.id.to_s
          end
          text member.name
        end
      end
    end
    mount Shared::FieldErrors, operation.participant_ids
  end

  private def participant_names(step : RaidStep) : String
    ids = row.participants[step.id]? || [] of Int64
    French.names(members.select { |member| ids.includes?(member.id) }.map(&.name))
  end
end
