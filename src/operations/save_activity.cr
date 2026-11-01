# An activity as a parent fills it in: dates and times as typed in the form
# (Paris wall clock), participants, and the usual drivers when a ride is
# needed.
class SaveActivity < Activity::SaveOperation
  param_key :activity
  DATE_FORMAT  = "%F"
  TIME_PATTERN = /\A(\d{1,2}):(\d{2})\z/

  permit_columns title, place, weekly, needs_ride, driver_to_id, driver_back_id
  attribute start_date : String
  attribute last_date : String
  attribute start_time : String
  attribute end_time : String
  attribute participant_ids : Array(Int64)

  before_save do
    validate_required title, message: "Donnez un nom à l'activité."
    set_dates
    set_times
    check_drivers
  end

  after_save replace_participants

  def self.form_for(activity : Activity) : self
    new(activity,
      start_date: AgendaBoard.paris(activity.starts_on).to_s(DATE_FORMAT),
      last_date: activity.last_day.try { |last| AgendaBoard.paris(last).to_s(DATE_FORMAT) } || "",
      start_time: clock(activity.start_minutes), end_time: clock(activity.end_minutes),
      participant_ids: ActivityParticipantQuery.new.activity_id(activity.id).map(&.user_id))
  end

  def self.clock(minutes : Int32) : String
    "%02d:%02d" % {minutes // 60, minutes % 60}
  end

  private def set_dates
    start = parse_date(start_date.value)
    return start_date.add_error("Indiquez la date de début.") unless start
    starts_on.value = start

    last = parse_date(last_date.value)
    if weekly.value && last
      return last_date.add_error("La fin doit venir après le début.") if last < start
      last_day.value = last
    else
      last_day.value = nil
    end
  end

  private def set_times
    from = minutes(start_time.value)
    to = minutes(end_time.value)
    return start_time.add_error("Indiquez l'heure de début, par exemple 14:00.") unless from
    return end_time.add_error("Indiquez l'heure de fin, par exemple 15:30.") unless to
    return end_time.add_error("La fin doit venir après le début.") unless to > from
    start_minutes.value = from
    end_minutes.value = to
  end

  # Only parents and grandparents drive; no ride needed, no drivers.
  private def check_drivers
    unless needs_ride.value
      driver_to_id.value = nil
      driver_back_id.value = nil
      return
    end
    {driver_to_id, driver_back_id}.each do |driver|
      id = driver.value
      next unless id
      unless UserQuery.new.id(id).first?.try(&.role.drive?)
        driver.add_error "Seuls les parents et les grands-parents conduisent."
      end
    end
  end

  private def replace_participants(activity : Activity)
    ids = (participant_ids.value || [] of Int64).uniq
    ActivityParticipantQuery.new.activity_id(activity.id).delete
    UserQuery.new.id.in(ids).each do |member|
      ActivityParticipant::SaveOperation.create!(activity_id: activity.id, user_id: member.id)
    end
  end

  private def parse_date(value : String?) : Time?
    Time.parse(value.to_s.strip, DATE_FORMAT, Household::TIME_ZONE)
  rescue Time::Format::Error
    nil
  end

  private def minutes(value : String?) : Int32?
    match = TIME_PATTERN.match(value.to_s.strip)
    return unless match
    hours, mins = match[1].to_i, match[2].to_i
    hours * 60 + mins if hours < 24 && mins < 60
  end
end
