require "../../spec_helper"

describe Canteen::Index do
  it "shows a daughter next week's canteen days of her school" do
    lina = pupil("Lina", school("École du Parc"))

    response = AppClient.new.exec(Canteen::Index, backdoor_user_id: lina.id)

    response.status_code.should eq(200)
    response.body.should contain("École du Parc")
    response.body.scan("canteen_week:dishes[]").size.should eq(5)
  end

  it "asks a daughter without a school to see a parent" do
    response = AppClient.new.exec(Canteen::Index, backdoor_user_id: child.id)

    response.body.should contain("Demande à un parent de choisir ton école")
  end

  it "does not exist for a parent or a guest" do
    AppClient.new.exec(Canteen::Index, backdoor_user_id: UserFactory.create.id).status_code.should eq(404)
    AppClient.new.exec(Canteen::Index, backdoor_user_id: guest.id).status_code.should eq(404)
  end
end
