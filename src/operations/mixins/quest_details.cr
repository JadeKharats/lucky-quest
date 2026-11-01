# Title, recurrence and XP, as a parent fills them in. The days arrive as
# checkbox values "1" (Monday) … "7" (Sunday).
module QuestDetails
  macro included
    attribute days : Array(Int32)
    before_save check_quest_details
  end

  private def check_quest_details
    validate_required title, message: "Donnez un titre à la quête."
    validate_required frequency, message: "Choisissez une fréquence."
    validate_numeric xp, at_least: 1, no_more_than: 1000, message: "Donnez entre 1 et 1000 XP."
    days_mask.value = chosen_days_mask
  end

  private def chosen_days_mask : Int32
    return 0 unless frequency.value.try(&.weekdays?)

    chosen = (days.value || [] of Int32).compact_map { |value| Time::DayOfWeek.from_value?(value) }
    if chosen.empty?
      days.add_error "Choisissez au moins un jour."
      0
    else
      Quests::Recurrence.on(chosen).mask
    end
  end
end
