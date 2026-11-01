require "../spec_helper"

private def dressed(member : User, skin : String) : User
  User::SaveOperation.update!(member, skin: Appearance::Skin.parse(skin))
end

describe "Skins" do
  it "lets a member choose her own skin" do
    lina = child

    response = AppClient.new.exec(Appearances::Choose, backdoor_user_id: lina.id, appearance: {skin: "Galaxy"})

    response.headers["Location"].should eq(Home::Index.path)
    lina.reload.skin.should eq(Appearance::Skin::Galaxy)
  end

  it "refuses an unknown skin" do
    lina = child

    AppClient.new.exec(Appearances::Choose, backdoor_user_id: lina.id, appearance: {skin: "Pirate"})

    lina.reload.skin.should eq(Appearance::Skin::Classic)
  end

  it "dresses the page in the member's skin" do
    body = AppClient.new.exec(Home::Index, backdoor_user_id: dressed(child, "System").id).body

    body.should contain(%(data-skin="system"))
    body.should contain("[SYSTÈME] Bienvenue, Lina.")
  end

  it "speaks Galaxie on the home page, the raid and the shop" do
    floor = the_floor_raid
    lina = dressed(floor.lina, "Galaxy")
    QuestFactory.create &.user_id(lina.id).title("Mettre la table")
    earn(lina, 200)

    home = AppClient.new.exec(Home::Index, backdoor_user_id: lina.id).body
    home.should contain("Bienvenue à bord, Lina.")
    home.should contain("Missions du jour")
    home.should contain("Mission accomplie")
    home.should contain("Cadet")
    home.should contain("200 crédits")
    home.should contain("Opération : Le Sol")

    shop = AppClient.new.exec(Rewards::Index, backdoor_user_id: lina.id).body
    shop.should contain("<h1>Comptoir</h1>")
    shop.should contain("Ton solde : 200 crédits")
  end

  it "uses the viewer's words for someone else's progression" do
    lina = child("Lina")
    earn(lina, 600)
    quest = QuestFactory.create &.user_id(lina.id)
    CompletionFactory.create &.quest_id(quest.id)

    AppClient.new.exec(Members::Index, backdoor_user_id: dressed(UserFactory.create, "Galaxy").id).body.should contain("Pilote · 600 crédits")
    AppClient.new.exec(Home::Index, backdoor_user_id: dressed(guest, "Galaxy").id).body.should contain("1 mission à valider")
  end
end
