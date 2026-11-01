require "../spec_helper"

private def words(skin) : Lexicon
  Lexicon.for(Appearance::Skin.parse(skin))
end

describe Lexicon do
  it "greets the member in each skin" do
    words("Classic").greeting("Lina").should eq("Bonjour Lina !")
    words("System").greeting("Lina").should eq("[SYSTÈME] Bienvenue, Lina.")
    words("Galaxy").greeting("Lina").should eq("Bienvenue à bord, Lina.")
  end

  it "names the quests of the day and the week" do
    {words("Classic").today, words("System").today, words("Galaxy").today}.should eq({"Aujourd'hui", "Quêtes quotidiennes", "Missions du jour"})
    {words("Classic").this_week, words("System").this_week, words("Galaxy").this_week}.should eq({"Cette semaine", "Quêtes hebdomadaires", "Missions de la semaine"})
    {words("Classic").done, words("System").done, words("Galaxy").done}.should eq({"C'est fait !", "Accomplir", "Mission accomplie"})
  end

  it "counts points as XP, or as crédits in Galaxie" do
    words("Classic").points(120).should eq("120 XP")
    words("System").points(1).should eq("1 XP")
    words("Galaxy").points(120).should eq("120 crédits")
    words("Galaxy").points(1).should eq("1 crédit")
  end

  it "names the ranks: letters, or generic grades in Galaxie" do
    Progression::Rank.values.map { |rank| words("Classic").rank(rank) }.should eq(["Rang E", "Rang D", "Rang C", "Rang B", "Rang A", "Rang S"])
    Progression::Rank.values.map { |rank| words("System").rank(rank) }.should eq(["Rang E", "Rang D", "Rang C", "Rang B", "Rang A", "Rang S"])
    Progression::Rank.values.map { |rank| words("Galaxy").rank(rank) }.should eq(["Recrue", "Cadet", "Pilote", "Capitaine", "Commandant", "Amiral"])
  end

  it "says what is left before the next rank" do
    words("Classic").next_rank(300, Progression::Rank::C).should eq("encore 300 XP pour le rang C")
    words("Galaxy").next_rank(300, Progression::Rank::C).should eq("encore 300 crédits pour devenir Pilote")
  end

  it "names the raid, the shop and the streak" do
    {words("Classic").raid("Le Sol"), words("System").raid("Le Sol"), words("Galaxy").raid("Le Sol")}.should eq({"Raid : Le Sol", "Portail : Le Sol", "Opération : Le Sol"})
    words("System").raid_finished.should eq("Portail fermé. Toute l'équipe progresse.")
    {words("Classic").shop, words("System").shop, words("Galaxy").shop}.should eq({"Boutique", "Boutique du Système", "Comptoir"})
    words("Classic").streak(1).should eq("Série : 1 jour 🔥")
    words("System").streak(5).should eq("Série : 5 jours ⚡")
    words("Galaxy").streak(5).should eq("Série : 5 jours ✨")
  end

  it "counts quests to validate with the right plural" do
    words("Classic").to_validate(1).should eq("1 quête à valider")
    words("Classic").to_validate(2).should eq("2 quêtes à valider")
    words("Galaxy").to_validate(2).should eq("2 missions à valider")
    {words("Classic").quests, words("Galaxy").quests}.should eq({"Quêtes", "Missions"})
  end
end
