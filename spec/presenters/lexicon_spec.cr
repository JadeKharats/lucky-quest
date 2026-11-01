require "../spec_helper"

private def words(skin) : Lexicon
  Lexicon.for(Appearance::Skin.parse(skin))
end

private def each_skin(& : Lexicon -> String) : Array(String)
  %w[Classic System Animals Dance].map { |skin| yield words(skin) }
end

describe Lexicon do
  it "greets the member in each skin" do
    each_skin(&.greeting("Lina")).should eq([
      "Salut Lina !", "[SYSTÈME] Bienvenue, Lina.", "Miaou, Lina !", "5, 6, 7, 8… À toi, Lina !",
    ])
  end

  it "names the quests, of the day and of the week" do
    each_skin(&.quests).should eq(["Quêtes", "Quêtes", "Défis", "Chorés"])
    each_skin(&.today).should eq(["Aujourd'hui", "Quêtes quotidiennes", "Les défis du jour", "La choré du jour"])
    each_skin(&.this_week).should eq(["Cette semaine", "Quêtes hebdomadaires", "Les défis de la semaine", "La choré de la semaine"])
    each_skin(&.no_quests).should eq([
      "Aucune quête pour l'instant.", "Aucune quête pour l'instant.",
      "Aucun défi pour l'instant.", "Aucune choré pour l'instant.",
    ])
  end

  it "says what a quest's button and states read" do
    each_skin(&.done).should eq(["C'est fait !", "Accomplir", "Fait !", "Fait !"])
    each_skin(&.awaiting).should eq(["Un parent va valider", "Validation en cours", "Un parent va valider", "Le prof va valider"])
    each_skin(&.validated).should eq(["Validée ✓", "[ OK ]", "Validé ✓", "Pose ! ✓"])
    each_skin(&.quest_done("Mettre la table")).should eq([
      "Bravo, « Mettre la table » est faite !", "[Quête accomplie] Mettre la table",
      "Bravo, défi « Mettre la table » réussi !", "Pose ! « Mettre la table » est dans la boîte.",
    ])
  end

  it "counts points as XP, croquettes or pas" do
    each_skin(&.points(120)).should eq(["120 XP", "120 XP", "120 croquettes", "120 pas"])
    each_skin(&.points(1)).should eq(["1 XP", "1 XP", "1 croquette", "1 pas"])
  end

  it "names the six ranks in each skin" do
    names = ->(skin : String) { Progression::Rank.values.map { |rank| words(skin).rank(rank) } }
    names.call("Classic").should eq(["Rang E", "Rang D", "Rang C", "Rang B", "Rang A", "Rang S"])
    names.call("System").should eq(["Rang E", "Rang D", "Rang C", "Rang B", "Rang A", "Rang S"])
    names.call("Animals").should eq(["Poussin", "Chaton", "Lapin", "Panda", "Girafe", "Lion"])
    names.call("Dance").should eq(["Échauffement", "Freestyle", "Battle", "Crew", "Chorégraphe", "Légende"])
  end

  it "says what is left before the next rank, and the top" do
    each_skin(&.next_rank(300, Progression::Rank::C)).should eq([
      "encore 300 XP pour le rang C", "encore 300 XP pour le rang C",
      "encore 300 croquettes pour devenir Lapin", "encore 300 pas pour passer Battle",
    ])
    each_skin(&.top_rank).should eq(["Rang maximal atteint !", "Rang maximal atteint !", "Tu es le Lion de la maison !", "Légende atteinte !"])
  end

  it "names the raid, its end and the shop" do
    each_skin(&.raid("Le Sol")).should eq(["Raid : Le Sol", "Portail : Le Sol", "Safari : Le Sol", "Flash mob : Le Sol"])
    each_skin(&.raid_finished).should eq([
      "Raid terminé, bravo à toute la famille !", "Portail fermé. Toute l'équipe progresse.",
      "Safari réussi, bravo la troupe !", "Flash mob réussi, bravo le crew !",
    ])
    each_skin(&.shop).should eq(["Boutique", "Boutique du Système", "Le Terrier", "Le Vestiaire"])
    each_skin(&.shop_tab).should eq(["Boutique", "Boutique", "Le Terrier", "Le Vestiaire"])
  end

  it "tells the streak with the right plural" do
    each_skin(&.streak(5)).should eq(["5 jours", "Série : 5", "5 jours", "5 jours d'affilée"])
    each_skin(&.streak(1)).should eq(["1 jour", "Série : 1", "1 jour", "1 jour d'affilée"])
  end

  it "counts quests to validate with the right plural" do
    each_skin(&.to_validate(1)).should eq(["1 quête à valider", "1 quête à valider", "1 défi à valider", "1 choré à valider"])
    each_skin(&.to_validate(2)).should eq(["2 quêtes à valider", "2 quêtes à valider", "2 défis à valider", "2 chorés à valider"])
  end

  it "names each skin on the picker" do
    Appearance::Skin.values.map { |skin| Lexicon.name(skin) }.should eq(["Classique", "Système", "Animaux", "Danse"])
  end
end
