require "../spec_helper"

private def dressed(member : User, skin : String) : User
  User::SaveOperation.update!(member, skin: Appearance::Skin.parse(skin))
end

describe "Skins" do
  it "lets a member choose her own skin, from the menu" do
    lina = child

    response = AppClient.new.exec(Appearances::Choose, backdoor_user_id: lina.id, appearance: {skin: "Animals"})

    response.headers["Location"].should eq(Menus::Show.path)
    lina.reload.skin.should eq(Appearance::Skin::Animals)
  end

  it "refuses an unknown skin, and Galaxie is gone" do
    lina = child

    AppClient.new.exec(Appearances::Choose, backdoor_user_id: lina.id, appearance: {skin: "Galaxy"})

    lina.reload.skin.should eq(Appearance::Skin::Classic)
  end

  it "offers the four skins on the menu" do
    body = AppClient.new.exec(Menus::Show, backdoor_user_id: child.id).body

    %w[classic system animals dance].each { |skin| body.should contain(%(class="skin-preview" data-skin="#{skin}")) }
    body.should contain("Classique ✓")
  end

  it "dresses the page in the member's skin and colour scheme" do
    system = AppClient.new.exec(Home::Index, backdoor_user_id: dressed(child, "System").id).body
    system.should contain(%(data-skin="system"))
    system.should contain(%(<meta name="color-scheme" content="dark">))
    system.should contain("[SYSTÈME] Bienvenue, Lina.")

    AppClient.new.exec(Home::Index, backdoor_user_id: dressed(child, "Animals").id).body.should contain(%(content="light"))
    AppClient.new.exec(Home::Index, backdoor_user_id: child.id).body.should contain(%(content="light dark"))
  end

  it "speaks Animaux on the home page, the raid and the shop" do
    floor = the_floor_raid
    lina = dressed(floor.lina, "Animals")
    QuestFactory.create &.user_id(lina.id).title("Mettre la table")
    earn(lina, 200)

    home = AppClient.new.exec(Home::Index, backdoor_user_id: lina.id).body
    home.should contain("Miaou, Lina !")
    home.should contain("Les défis du jour")
    home.should contain("Fait !")
    home.should contain("+10 croquettes")
    home.should contain("Chaton")
    home.should contain("200 croquettes")
    home.should contain("Safari : Le Sol")
    home.should contain("art-cat")
    home.should contain("art-giraffe")
    home.should contain("meter-animals")

    shop = AppClient.new.exec(Rewards::Index, backdoor_user_id: lina.id).body
    shop.should contain("<h1>Le Terrier</h1>")
    shop.should contain("Ton solde : 200 croquettes")
  end

  it "speaks Danse on the home page" do
    lina = dressed(child, "Dance")
    QuestFactory.create &.user_id(lina.id).title("Mettre la table")
    earn(lina, 600)

    home = AppClient.new.exec(Home::Index, backdoor_user_id: lina.id).body
    home.should contain("5, 6, 7, 8… À toi, Lina !")
    home.should contain("La choré du jour")
    home.should contain("Battle")
    home.should contain("encore 600 pas pour passer Crew")
    home.should contain("art-dancer")
    home.should contain("meter-dance")
  end

  it "lights the meter in proportion to the rank's progress" do
    lina = dressed(child, "Animals")
    earn(lina, 850) # C starts at 500, B at 1200: halfway

    home = AppClient.new.exec(Home::Index, backdoor_user_id: lina.id).body
    home.scan("meter-cell meter-on").size.should eq(5)
    home.scan(%(class="meter-cell")).size.should eq(5)
  end

  it "uses the viewer's words for someone else's progression" do
    lina = child("Lina")
    earn(lina, 600)
    quest = QuestFactory.create &.user_id(lina.id)
    CompletionFactory.create &.quest_id(quest.id)

    AppClient.new.exec(Members::Index, backdoor_user_id: dressed(UserFactory.create, "Dance").id).body.should contain("Battle · 600 pas")
    AppClient.new.exec(Home::Index, backdoor_user_id: dressed(guest, "Animals").id).body.should contain("1 défi à valider")
  end
end
