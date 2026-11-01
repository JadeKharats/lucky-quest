# Loads the activities and their changes into the domain's schedule.
module AgendaBoard
  def self.schedule : Agenda::Schedule
    activities = ActivityQuery.ordered.to_a
    participants = ActivityParticipantQuery.new.id.asc_order.to_a.group_by(&.activity_id)
    domain = activities.map do |activity|
      ids = (participants[activity.id]? || [] of ActivityParticipant).map(&.user_id)
      to_domain(activity, ids)
    end
    Agenda::Schedule.new(domain, ActivityChangeQuery.new.to_a.map(&.to_domain))
  end

  # The occurrence of an activity on a day, if there is one.
  def self.occurrence(activity_id : Int64, day : Time) : Agenda::Occurrence?
    schedule.between(day, day.shift(days: 1)).find { |found| found.activity.id == activity_id }
  end

  def self.names : Hash(Int64, String)
    UserQuery.new.to_a.to_h { |member| {member.id, member.name} }
  end

  # The database gives times back in UTC: the schedule works on Paris days
  # and wall-clock times.
  def self.paris(time : Time) : Time
    time.in(Household::TIME_ZONE)
  end

  private def self.to_domain(activity : Activity, participant_ids : Array(Int64)) : Agenda::Activity
    Agenda::Activity.new(
      id: activity.id, title: activity.title, place: activity.place, starts_on: paris(activity.starts_on),
      start_minutes: activity.start_minutes, end_minutes: activity.end_minutes,
      weekly: activity.weekly, last_day: activity.last_day.try { |last| paris(last) }, participant_ids: participant_ids,
      needs_ride: activity.needs_ride,
      usual: Agenda::Drivers.new(to: activity.driver_to_id, back: activity.driver_back_id),
    )
  end
end
