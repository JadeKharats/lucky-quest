require "../spec_helper"

describe "Meals flow", tags: "flow" do
  it "warns a parent who plans at home what the canteen serves" do
    lina = pupil("Lina", school("École du Parc"))
    monday = next_monday.to_s("%F")
    flow = BaseFlow.new

    flow.visit Canteen::Index, as: lina
    flow.fill flow.el("@canteen_#{monday}_dish"), with: "Lasagnes"
    flow.click "@save-canteen"
    flow.should have_element("@flash", text: "Menu de la cantine enregistré")

    flow.visit Meals::Index.with(semaine: monday), as: UserFactory.create
    flow.click "@meal_#{monday}_diner_open"
    flow.fill flow.el("@meal_#{monday}_diner_dish"), with: "lasagne"
    flow.click "@meal_#{monday}_diner_save"

    flow.should have_element(".meal-warning", text: "⛔ Lasagnes à la cantine de Lina ce midi")
  end
end
