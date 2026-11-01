require "../../spec_helper"

describe "Progression on the family page" do
  it "shows a parent each member's rank and XP" do
    lina = child("Lina")
    earn(lina, 600)

    body = AppClient.new.exec(Members::Index, backdoor_user_id: UserFactory.create.id).body

    body.should contain("Rang C · 600 XP")
  end
end
