# Frequency, plus the days when it is "Certains jours". Plain inputs: the
# days are an array attribute (`quest:days[]`).
class Quests::RecurrenceFields < BaseComponent
  needs frequency : Avram::PermittedAttribute(Quests::Frequency)
  needs days : Avram::PermittedAttribute(Array(Int32))
  needs id_prefix : String

  def render
    label "Fréquence", for: "#{id_prefix}_frequency"
    select_input frequency, id: "#{id_prefix}_frequency" do
      options_for_select frequency, Quests::Frequency.values.map { |value| {French.frequency(value), value} }
    end
    days_fields
  end

  private def days_fields
    chosen = days.value || [] of Int32
    fieldset class: "days" do
      legend "Jours (si « Certains jours »)"
      Time::DayOfWeek.values.each do |day|
        label class: "day" do
          if chosen.includes?(day.value)
            input type: "checkbox", name: "quest:days[]", value: day.value.to_s, checked: "checked"
          else
            input type: "checkbox", name: "quest:days[]", value: day.value.to_s
          end
          text French.weekday(day)
        end
      end
    end
    mount Shared::FieldErrors, days
  end
end
