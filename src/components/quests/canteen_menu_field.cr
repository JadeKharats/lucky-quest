class Quests::CanteenMenuField < BaseComponent
  needs attribute : Avram::PermittedAttribute(Bool)
  needs id : String

  def render
    label class: "day", for: id do
      checkbox attribute, id: id
      text "Menu de la cantine (faite toute seule quand la semaine suivante est saisie)"
    end
  end
end
