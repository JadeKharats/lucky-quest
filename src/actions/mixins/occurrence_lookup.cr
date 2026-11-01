# The occurrence a URL names by its activity and day, and the trip's leg.
module OccurrenceLookup
  LEGS = {"aller" => Agenda::Leg::To, "retour" => Agenda::Leg::Back}

  private def occurrence_for(activity_id : String, date : String) : Agenda::Occurrence
    AgendaBoard.occurrence(activity_id.to_i64, parse_day(date)) || raise Lucky::RouteNotFoundError.new(context)
  end

  private def leg_for(value : String) : Agenda::Leg
    LEGS[value]? || raise Lucky::RouteNotFoundError.new(context)
  end

  private def back_to_week(occurrence : Agenda::Occurrence)
    redirect Schedules::Index.with(semaine: occurrence.day.at_beginning_of_week.to_s(WeekParam::DATE_FORMAT))
  end
end
