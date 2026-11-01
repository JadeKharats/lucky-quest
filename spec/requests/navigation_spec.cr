require "../spec_helper"

private def tabs(member : User, page = Home::Index) : Array(String)
  AppClient.new.exec(page, backdoor_user_id: member.id).body.scan(/flow-id="tab-([a-z]+)"/).map(&.[1])
end

describe "Navigation" do
  it "gives the children five tabs, the shop among them" do
    tabs(child).should eq(%w[home meals agenda shop more])
  end

  it "gives parents and guests the validations instead of the shop" do
    tabs(UserFactory.create).should eq(%w[home validate meals agenda more])
    tabs(guest).should eq(%w[home validate meals agenda more])
  end

  it "marks the current page's tab" do
    body = AppClient.new.exec(Meals::Index, backdoor_user_id: child.id).body
    body.should contain(%(class="tab tab-current" flow-id="tab-meals" aria-current="page"))
  end

  it "names the shop tab in the member's words" do
    lina = User::SaveOperation.update!(child, skin: Appearance::Skin::Dance)
    AppClient.new.exec(Home::Index, backdoor_user_id: lina.id).body.should contain(%(<span class="tab-label">Le Vestiaire</span>))
  end
end

describe "Menu" do
  it "lists the rest of a parent's pages and signing out" do
    body = AppClient.new.exec(Menus::Show, backdoor_user_id: UserFactory.create.id).body

    body.scan(/flow-id="menu-([a-z]+)"/).map(&.[1]).should eq(%w[quests shop weight family])
    body.should contain(%(flow-id="sign-out-button"))
    body.should contain("Mon apparence")
  end

  it "shows a daughter her canteen menu and nothing she may not use" do
    body = AppClient.new.exec(Menus::Show, backdoor_user_id: child.id).body

    body.scan(/flow-id="menu-([a-z]+)"/).map(&.[1]).should eq(%w[canteen])
  end

  it "shows a guest only her skin and signing out" do
    body = AppClient.new.exec(Menus::Show, backdoor_user_id: guest.id).body

    body.should_not contain("menu-link")
    body.should contain(%(flow-id="sign-out-button"))
  end

  it "needs a signed-in member" do
    AppClient.new.exec(Menus::Show).headers["Location"].should eq(SignIns::New.path)
  end
end

describe "Fonts" do
  it "ships each font file with its licence" do
    Dir.glob("public/fonts/*.woff2").size.should eq(8)
    Dir.glob("public/fonts/licenses/*").size.should eq(7)
  end
end
