require "../../spec_helper"

describe Meals::Index do
  it "shows everyone the week with the canteens and a conflict's reason" do
    parc = school("École du Parc")
    pupil("Lina", parc)
    CanteenMeal::SaveOperation.create!(school_id: parc.id, day: next_monday, dish: "Lasagnes", tag: Meals::MainTag::Pasta)
    HomeMeal::SaveOperation.create!(day: next_monday, slot: Meals::Slot::Dinner, dish: "lasagne", tag: Meals::MainTag::Pasta)

    [UserFactory.create, child("Emma"), guest].each do |member|
      response = AppClient.new.exec(Meals::Index.with(semaine: next_monday.to_s("%F")), backdoor_user_id: member.id)

      response.status_code.should eq(200)
      response.body.should contain("École du Parc")
      response.body.should contain("⛔ Lasagnes à la cantine de Lina ce midi")
    end
  end

  it "shows the current week by default" do
    response = AppClient.new.exec(Meals::Index, backdoor_user_id: UserFactory.create.id)

    response.body.should contain("Semaine du #{French.date(today_in_paris.at_beginning_of_week)}")
  end
end
