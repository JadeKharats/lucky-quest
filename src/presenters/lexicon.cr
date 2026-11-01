# The game's words in each skin, as the viewer sees them. Only the game is
# reskinned: meals, agenda, weight and family keep their plain words. Each
# `case` is exhaustive, so a new skin cannot forget a word.
struct Lexicon
  GALAXY_RANKS = %w[Recrue Cadet Pilote Capitaine Commandant Amiral]

  getter skin : Appearance::Skin

  def self.for(skin : Appearance::Skin) : self
    new(skin)
  end

  def initialize(@skin : Appearance::Skin)
  end

  def greeting(name : String) : String
    case skin
    in .classic? then "Bonjour #{name} !"
    in .system?  then "[SYSTÈME] Bienvenue, #{name}."
    in .galaxy?  then "Bienvenue à bord, #{name}."
    end
  end

  def quests : String
    skin.galaxy? ? "Missions" : "Quêtes"
  end

  def today : String
    case skin
    in .classic? then "Aujourd'hui"
    in .system?  then "Quêtes quotidiennes"
    in .galaxy?  then "Missions du jour"
    end
  end

  def this_week : String
    case skin
    in .classic? then "Cette semaine"
    in .system?  then "Quêtes hebdomadaires"
    in .galaxy?  then "Missions de la semaine"
    end
  end

  def no_quests : String
    skin.galaxy? ? "Aucune mission pour l'instant." : "Aucune quête pour l'instant."
  end

  def done : String
    case skin
    in .classic? then "C'est fait !"
    in .system?  then "Accomplir"
    in .galaxy?  then "Mission accomplie"
    end
  end

  def quest_done(title : String) : String
    case skin
    in .classic? then "Bravo, « #{title} » est faite !"
    in .system?  then "[Quête accomplie] #{title}"
    in .galaxy?  then "Mission accomplie : #{title}"
    end
  end

  def to_validate(count : Int) : String
    noun = skin.galaxy? ? "mission" : "quête"
    "#{count} #{noun}#{count == 1 ? "" : "s"} à valider"
  end

  def points(amount : Int) : String
    return "#{amount} XP" unless skin.galaxy?
    "#{amount} crédit#{amount.abs == 1 ? "" : "s"}"
  end

  def rank(rank : Progression::Rank) : String
    skin.galaxy? ? GALAXY_RANKS[rank.value] : "Rang #{rank}"
  end

  def next_rank(missing : Int, rank : Progression::Rank) : String
    goal = skin.galaxy? ? "devenir #{rank(rank)}" : "le rang #{rank}"
    "encore #{points(missing)} pour #{goal}"
  end

  def top_rank : String
    skin.galaxy? ? "Grade le plus haut atteint !" : "Rang maximal atteint !"
  end

  def streak(days : Int) : String
    icon = case skin
           in .classic? then "🔥"
           in .system?  then "⚡"
           in .galaxy?  then "✨"
           end
    "Série : #{days} jour#{days == 1 ? "" : "s"} #{icon}"
  end

  def raid(title : String) : String
    case skin
    in .classic? then "Raid : #{title}"
    in .system?  then "Portail : #{title}"
    in .galaxy?  then "Opération : #{title}"
    end
  end

  def raid_finished : String
    case skin
    in .classic? then "Raid terminé, bravo à toute la famille !"
    in .system?  then "Portail fermé. Toute l'équipe progresse."
    in .galaxy?  then "Opération réussie, bravo l'équipage !"
    end
  end

  def shop : String
    case skin
    in .classic? then "Boutique"
    in .system?  then "Boutique du Système"
    in .galaxy?  then "Comptoir"
    end
  end

  # How each skin is called on the "Mon apparence" card.
  def self.name(skin : Appearance::Skin) : String
    case skin
    in .classic? then "Classique"
    in .system?  then "Système"
    in .galaxy?  then "Galaxie"
    end
  end
end
