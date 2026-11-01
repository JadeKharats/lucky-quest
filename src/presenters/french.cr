# How numbers and dates read on a French screen.
module French
  extend self

  MONTHS = %w[janv. févr. mars avr. mai juin juil. août sept. oct. nov. déc.]

  def kilograms(value : Float64) : String
    "#{decimal(value)} kg"
  end

  # "−0,4 kg" with a true minus sign, "+0,3 kg", "0,0 kg".
  def delta(value : Float64) : String
    rounded = value.round(1)
    sign = rounded.negative? ? "−" : (rounded.positive? ? "+" : "")
    "#{sign}#{kilograms(rounded.abs)}"
  end

  def date(time : Time) : String
    "#{time.day} #{MONTHS[time.month - 1]}"
  end

  ROLES = {
    Family::Role::Parent => "Parent",
    Family::Role::Child  => "Enfant",
    Family::Role::Guest  => "Invité·e",
  }

  def role(role : Family::Role) : String
    ROLES[role]
  end

  FREQUENCIES = {
    Quests::Frequency::Daily    => "Tous les jours",
    Quests::Frequency::Weekdays => "Certains jours",
    Quests::Frequency::Weekly   => "Une fois par semaine",
  }

  STEP_RULES = {
    Quests::StepRule::Everyone => "Chacun sa part",
    Quests::StepRule::Anyone   => "Un seul suffit",
  }

  def step_rule(rule : Quests::StepRule) : String
    STEP_RULES[rule]
  end

  # "Lina", "Lina et Emma", "Lina, Emma et David".
  def names(list : Array(String)) : String
    return list.join if list.size < 2
    "#{list[0..-2].join(", ")} et #{list.last}"
  end

  TAGS = {
    Meals::MainTag::Pasta      => "pâtes",
    Meals::MainTag::Rice       => "riz",
    Meals::MainTag::Potatoes   => "pommes de terre",
    Meals::MainTag::Legumes    => "légumineuses",
    Meals::MainTag::Fish       => "poisson",
    Meals::MainTag::Poultry    => "volaille",
    Meals::MainTag::Beef       => "bœuf",
    Meals::MainTag::Pork       => "porc",
    Meals::MainTag::Lamb       => "agneau",
    Meals::MainTag::Eggs       => "œufs",
    Meals::MainTag::PizzaTart  => "pizza / tarte",
    Meals::MainTag::Vegetarian => "végétarien",
    Meals::MainTag::Other      => "autre",
  }

  def tag(tag : Meals::MainTag) : String
    TAGS[tag]
  end

  # "lun. 9 nov."
  def weekday_date(day : Time) : String
    "#{weekday(day.day_of_week)} #{date(day)}"
  end

  WEEKDAYS = %w[lun. mar. mer. jeu. ven. sam. dim.]

  def frequency(frequency : Quests::Frequency) : String
    FREQUENCIES[frequency]
  end

  def weekday(day : Time::DayOfWeek) : String
    WEEKDAYS[day.value - 1]
  end

  # "Tous les jours", "lun., ven.", "Une fois par semaine".
  def recurrence(recurrence : Quests::Recurrence) : String
    return frequency(recurrence.frequency) unless recurrence.frequency.weekdays?
    recurrence.days.to_a.sort_by(&.value).join(", ") { |day| weekday(day) }
  end

  # The occurrence a completion belongs to: "4 nov." or "semaine du 2 nov.".
  def period(start : Time, weekly : Bool) : String
    weekly ? "semaine du #{date(start)}" : date(start)
  end

  def date_time(time : Time) : String
    "#{date(time)} à #{time.to_s("%H:%M")}"
  end

  private def decimal(value : Float64) : String
    value.round(1).format(decimal_places: 1).tr(".", ",")
  end
end
