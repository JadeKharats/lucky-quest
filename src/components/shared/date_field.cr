# A plain date input for a String attribute holding "YYYY-MM-DD": Avram's
# date_input expects a Time attribute.
class Shared::DateField < BaseComponent
  needs attribute : Avram::PermittedAttribute(String)
  needs label_text : String
  needs id : String

  def render
    label label_text, for: id
    input type: "date", id: id, name: "#{attribute.param_key}:#{attribute.name}", value: attribute.value.to_s
    mount Shared::FieldErrors, attribute
  end
end
