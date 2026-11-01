module Agenda
  # The occurrences of the activities between two days (`from` included,
  # `to` excluded), with their changes applied.
  class Schedule
    def initialize(@activities : Array(Activity), @changes : Array(Change))
    end

    def between(from : Time, to : Time) : Array(Occurrence)
      @activities.flat_map { |activity| occurrences(activity, from, to) }.sort_by!(&.starts_at)
    end

    def open_trips(from : Time, to : Time) : Array(Trip)
      between(from, to).reject(&.cancelled).flat_map(&.trips).select { |trip| trip.driver_id.nil? }
    end

    def for_member(member_id : Int64, from : Time, to : Time) : Array(Occurrence)
      between(from, to).select { |occurrence| !occurrence.cancelled && occurrence.involves?(member_id) }
    end

    private def occurrences(activity : Activity, from : Time, to : Time) : Array(Occurrence)
      days(activity, from, to).map { |day| occurrence(activity, day) }
    end

    private def days(activity : Activity, from : Time, to : Time) : Array(Time)
      start = activity.starts_on
      return once(start, from, to) unless activity.weekly

      day = from > start ? from.at_beginning_of_day : start
      while day.day_of_week != start.day_of_week
        day = day.shift(days: 1)
      end
      found = [] of Time
      while day < to && within_last_day?(activity, day)
        found << day
        day = day.shift(days: 7)
      end
      found
    end

    private def once(day : Time, from : Time, to : Time) : Array(Time)
      from <= day && day < to ? [day] : [] of Time
    end

    private def within_last_day?(activity : Activity, day : Time) : Bool
      last = activity.last_day
      last.nil? || day <= last
    end

    private def occurrence(activity : Activity, day : Time) : Occurrence
      change = @changes.find { |candidate| candidate.activity_id == activity.id && candidate.day == day }
      Occurrence.new(
        activity: activity, day: day,
        starts_at: at(day, activity.start_minutes), ends_at: at(day, activity.end_minutes),
        cancelled: change.try(&.cancelled) || false,
        drivers: change.try(&.drivers) || activity.usual,
      )
    end

    # DST-safe: built from the calendar date, not by adding seconds.
    private def at(day : Time, minutes : Int32) : Time
      Time.local(day.year, day.month, day.day, minutes // 60, minutes % 60, location: day.location)
    end
  end
end
