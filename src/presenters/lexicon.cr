# The game's words in each skin, as the viewer sees them. Only the game is
# reskinned: meals, agenda, weight and family keep their plain words. Each
# `case` is exhaustive, so a new skin cannot forget a word.
struct Lexicon
  ANIMAL_RANKS = %w[Poussin Chaton Lapin Panda Girafe Lion]
  DANCE_RANKS  = %w[Échauffement Freestyle Battle Crew Chorégraphe Légende]

  getter skin : Appearance::Skin

  def self.for(skin : Appearance::Skin) : self
    new(skin)
  end

  def initialize(@skin : Appearance::Skin)
  end

  # How each skin is called on the "Mon apparence" card.
  def self.name(skin : Appearance::Skin) : String
    case skin
    in .classic? then "Classique"
    in .system?  then "Système"
    in .animals? then "Animaux"
    in .dance?   then "Danse"
    end
  end

  def greeting(name : String) : String
    case skin
    in .classic? then "Salut #{name} !"
    in .system?  then "[SYSTÈME] Bienvenue, #{name}."
    in .animals? then "Miaou, #{name} !"
    in .dance?   then "5, 6, 7, 8… À toi, #{name} !"
    end
  end

  def quests : String
    case skin
    in .classic?, .system? then "Quêtes"
    in .animals?           then "Défis"
    in .dance?             then "Chorés"
    end
  end

  def today : String
    case skin
    in .classic? then "Aujourd'hui"
    in .system?  then "Quêtes quotidiennes"
    in .animals? then "Les défis du jour"
    in .dance?   then "La choré du jour"
    end
  end

  def this_week : String
    case skin
    in .classic? then "Cette semaine"
    in .system?  then "Quêtes hebdomadaires"
    in .animals? then "Les défis de la semaine"
    in .dance?   then "La choré de la semaine"
    end
  end

  def no_quests : String
    case skin
    in .classic?, .system? then "Aucune quête pour l'instant."
    in .animals?           then "Aucun défi pour l'instant."
    in .dance?             then "Aucune choré pour l'instant."
    end
  end

  def done : String
    case skin
    in .classic?          then "C'est fait !"
    in .system?           then "Accomplir"
    in .animals?, .dance? then "Fait !"
    end
  end

  # A quest done, waiting for a parent or a guest.
  def awaiting : String
    case skin
    in .classic?, .animals? then "Un parent va valider"
    in .system?             then "Validation en cours"
    in .dance?              then "Le prof va valider"
    end
  end

  def validated : String
    case skin
    in .classic? then "Validée ✓"
    in .system?  then "[ OK ]"
    in .animals? then "Validé ✓"
    in .dance?   then "Pose ! ✓"
    end
  end

  def quest_done(title : String) : String
    case skin
    in .classic? then "Bravo, « #{title} » est faite !"
    in .system?  then "[Quête accomplie] #{title}"
    in .animals? then "Bravo, défi « #{title} » réussi !"
    in .dance?   then "Pose ! « #{title} » est dans la boîte."
    end
  end

  def to_validate(count : Int) : String
    noun = case skin
           in .classic?, .system? then "quête"
           in .animals?           then "défi"
           in .dance?             then "choré"
           end
    "#{count} #{noun}#{plural(count)} à valider"
  end

  def points(amount : Int) : String
    case skin
    in .classic?, .system? then "#{amount} XP"
    in .animals?           then "#{amount} croquette#{plural(amount)}"
    in .dance?             then "#{amount} pas"
    end
  end

  def rank(rank : Progression::Rank) : String
    case skin
    in .classic?, .system? then "Rang #{rank}"
    in .animals?           then ANIMAL_RANKS[rank.value]
    in .dance?             then DANCE_RANKS[rank.value]
    end
  end

  def next_rank(missing : Int, rank : Progression::Rank) : String
    goal = case skin
           in .classic?, .system? then "le rang #{rank}"
           in .animals?           then "devenir #{rank(rank)}"
           in .dance?             then "passer #{rank(rank)}"
           end
    "encore #{points(missing)} pour #{goal}"
  end

  def top_rank : String
    case skin
    in .classic?, .system? then "Rang maximal atteint !"
    in .animals?           then "Tu es le Lion de la maison !"
    in .dance?             then "Légende atteinte !"
    end
  end

  def streak(days : Int) : String
    case skin
    in .classic?, .animals? then "#{days} jour#{plural(days)}"
    in .system?             then "Série : #{days}"
    in .dance?              then "#{days} jour#{plural(days)} d'affilée"
    end
  end

  def raid(title : String) : String
    case skin
    in .classic? then "Raid : #{title}"
    in .system?  then "Portail : #{title}"
    in .animals? then "Safari : #{title}"
    in .dance?   then "Flash mob : #{title}"
    end
  end

  def raid_finished : String
    case skin
    in .classic? then "Raid terminé, bravo à toute la famille !"
    in .system?  then "Portail fermé. Toute l'équipe progresse."
    in .animals? then "Safari réussi, bravo la troupe !"
    in .dance?   then "Flash mob réussi, bravo le crew !"
    end
  end

  def shop : String
    case skin
    in .classic? then "Boutique"
    in .system?  then "Boutique du Système"
    in .animals? then "Le Terrier"
    in .dance?   then "Le Vestiaire"
    end
  end

  # The shop's name on a tab, where space is short.
  def shop_tab : String
    skin.system? ? "Boutique" : shop
  end

  private def plural(count : Int) : String
    count.abs == 1 ? "" : "s"
  end
end
