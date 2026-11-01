# Weeks travel in URLs as their Monday, "2026-11-09".
module WeekParam
  DATE_FORMAT = "%F"

  private def monday_of(value : String, default : Time) : Time
    day = value.empty? ? default : parse_day(value)
    day.at_beginning_of_week
  end

  private def parse_day(value : String) : Time
    Time.parse(value, DATE_FORMAT, Household::TIME_ZONE)
  rescue Time::Format::Error
    raise Lucky::RouteNotFoundError.new(context)
  end
end
