class Weighings::Form < BaseComponent
  needs operation : SaveWeighing

  def render
    section class: "card" do
      h2 "Nouvelle pesée"
      form_for Weighings::Create do
        mount Shared::Field, attribute: operation.weight, label_text: "Poids (kg)", &.text_input(inputmode: "decimal", autocomplete: "off", placeholder: "72,4", flow_id: "weight-input")
        measured_at_field
        submit "Enregistrer", flow_id: "save-weighing"
      end
    end
  end

  # A plain datetime-local input: the value is a Paris wall-clock time that
  # SaveWeighing interprets itself (Avram's datetime_input expects a Time).
  private def measured_at_field
    field = operation.measured_at_local
    label "Date et heure", for: "weighing_measured_at_local"
    input type: "datetime-local", id: "weighing_measured_at_local",
      name: "weighing:measured_at_local", value: field.value.to_s, required: "required"
    mount Shared::FieldErrors, field
  end
end
