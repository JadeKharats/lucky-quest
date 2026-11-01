class Members::SchoolList < BaseComponent
  needs schools : Array(School)

  def render
    section class: "card quests" do
      h2 "Écoles"
      ul do
        schools.each { |school| item(school) }
      end
      details class: "member-edit" do
        summary "Ajouter une école"
        form_for Schools::Create do
          fields(SaveSchool.new, "school_new")
          submit "Ajouter", flow_id: "add-school"
        end
      end
    end
  end

  private def item(school : School)
    li class: "quest" do
      div class: "quest-title" do
        strong school.name
        span "cantine : #{school.days.join(", ") { |day| French.weekday(day) }}", class: "quest-state"
      end
      details class: "member-edit" do
        summary "Modifier"
        form_for Schools::Update.with(school.id) do
          fields(SaveSchool.form_for(school), "school_#{school.id}")
          submit "Enregistrer"
        end
      end
    end
  end

  private def fields(operation : SaveSchool, prefix : String)
    mount Shared::Field, attribute: operation.name, label_text: "Nom", &.text_input(flow_id: "#{prefix}_name")
    chosen = operation.days.value || [] of Int32
    fieldset class: "days" do
      legend "Jours de cantine"
      Time::DayOfWeek.values.each do |day|
        label class: "day" do
          if chosen.includes?(day.value)
            input type: "checkbox", name: "school:days[]", value: day.value.to_s, checked: "checked"
          else
            input type: "checkbox", name: "school:days[]", value: day.value.to_s
          end
          text French.weekday(day)
        end
      end
    end
    mount Shared::FieldErrors, operation.days
  end
end
