# The parents' list of activities, with the forms to add and edit them.
class AgendaPlan::Activities < BaseComponent
  needs activities : Array(Activity)
  needs household : Array(User)

  def render
    h2 "Activités", class: "section-title"
    section class: "card quests" do
      ul do
        activities.each { |activity| item(activity) }
      end
      details class: "member-edit" do
        summary "Ajouter une activité"
        form_for ::Activities::Create do
          fields(SaveActivity.new(weekly: true, needs_ride: true), "activity_new")
          submit "Ajouter", flow_id: "add-activity"
        end
      end
    end
  end

  private def item(activity : Activity)
    li class: "quest" do
      div class: "quest-title" do
        strong activity.title
        span summary(activity), class: "quest-state"
      end
      details class: "member-edit" do
        summary "Modifier"
        form_for ::Activities::Update.with(activity.id) do
          fields(SaveActivity.form_for(activity), "activity_#{activity.id}")
          submit "Enregistrer"
        end
        if activity.weekly
          form_for(::Activities::End.with(activity.id), class: "secondary") { submit "Terminer l'activité" }
        end
      end
    end
  end

  private def summary(activity : Activity) : String
    starts_on = AgendaBoard.paris(activity.starts_on)
    day = French.weekday(starts_on.day_of_week)
    time = "#{SaveActivity.clock(activity.start_minutes)}–#{SaveActivity.clock(activity.end_minutes)}"
    if activity.weekly
      ending = activity.last_day.try { |last| " jusqu'au #{French.date(AgendaBoard.paris(last))}" } || ""
      "chaque #{day} #{time}#{ending}"
    else
      "#{French.weekday_date(starts_on)} #{time}"
    end
  end

  private def fields(operation : SaveActivity, prefix : String)
    mount Shared::Field, attribute: operation.title, label_text: "Activité", &.text_input(flow_id: "#{prefix}_title")
    mount Shared::Field, attribute: operation.place, label_text: "Lieu", &.text_input
    plain(operation.start_date, "Premier jour", "date", "#{prefix}_start_date")
    label(class: "day") { checkbox operation.weekly; text "Chaque semaine" }
    plain(operation.last_date, "Dernier jour (si chaque semaine, facultatif)", "date", "#{prefix}_last_date")
    plain(operation.start_time, "Début", "time", "#{prefix}_start_time")
    plain(operation.end_time, "Fin", "time", "#{prefix}_end_time")
    participants(operation)
    label(class: "day") { checkbox operation.needs_ride; text "Besoin d'être conduit·e" }
    driver_select(operation.driver_to_id, "Aller habituel", "#{prefix}_driver_to")
    driver_select(operation.driver_back_id, "Retour habituel", "#{prefix}_driver_back")
  end

  private def plain(attribute : Avram::PermittedAttribute(String), text_label : String, type : String, id : String)
    label text_label, for: id
    input type: type, id: id, name: "#{attribute.param_key}:#{attribute.name}", value: attribute.value.to_s, flow_id: id
    mount Shared::FieldErrors, attribute
  end

  private def participants(operation : SaveActivity)
    chosen = operation.participant_ids.value || [] of Int64
    fieldset class: "days" do
      legend "Participants"
      household.each do |member|
        label class: "day" do
          if chosen.includes?(member.id)
            input type: "checkbox", name: "activity:participant_ids[]", value: member.id.to_s, checked: "checked"
          else
            input type: "checkbox", name: "activity:participant_ids[]", value: member.id.to_s
          end
          text member.name
        end
      end
    end
  end

  private def driver_select(attribute : Avram::PermittedAttribute(Int64?), text_label : String, id : String)
    label text_label, for: id
    select_input attribute, id: id do
      option "personne", value: ""
      options_for_select attribute, household.select(&.role.drive?).map { |member| {member.name, member.id} }
    end
    mount Shared::FieldErrors, attribute
  end
end
