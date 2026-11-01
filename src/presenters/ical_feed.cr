# A member's calendar feed (RFC 5545): the activities she takes part in and
# the trips she drives, one event per occurrence, times in UTC.
class IcalFeed
  RIDE = 30.minutes
  LEGS = {Agenda::Leg::To => "aller", Agenda::Leg::Back => "retour"}

  def initialize(@occurrences : Array(Agenda::Occurrence), @member_id : Int64, @member_name : String,
                 @names : Hash(Int64, String), @now : Time = Time.utc)
  end

  def to_s(io : IO) : Nil
    lines = ["BEGIN:VCALENDAR", "VERSION:2.0", "PRODID:-//Quest//Agenda//FR", "CALSCALE:GREGORIAN",
             "X-WR-CALNAME:#{escape("Quest — #{@member_name}")}"]
    @occurrences.reject(&.cancelled).each { |occurrence| lines.concat(events(occurrence)) }
    lines << "END:VCALENDAR"
    lines.each { |line| io << IcalFeed.fold(line) << "\r\n" }
  end

  # Lines longer than 75 bytes go on, after a space, on the next line.
  def self.fold(line : String) : String
    parts = [] of String
    current = String::Builder.new
    size = 0
    line.each_char do |char|
      if size + char.bytesize > 74
        parts << current.to_s
        current = String::Builder.new
        current << ' '
        size = 1
      end
      current << char
      size += char.bytesize
    end
    parts << current.to_s
    parts.join("\r\n")
  end

  private def events(occurrence : Agenda::Occurrence) : Array(String)
    activity = occurrence.activity
    found = [] of String
    if activity.participant_ids.includes?(@member_id)
      found.concat(event(uid(occurrence), occurrence.starts_at, occurrence.ends_at, activity.title, activity.place))
    end
    occurrence.trips.select { |trip| trip.driver_id == @member_id }.each do |trip|
      found.concat(trip_event(occurrence, trip.leg))
    end
    found
  end

  private def trip_event(occurrence : Agenda::Occurrence, leg : Agenda::Leg) : Array(String)
    activity = occurrence.activity
    who = activity.participant_ids.compact_map { |id| @names[id]? }
    starts, ends = leg.to? ? {occurrence.starts_at - RIDE, occurrence.starts_at} : {occurrence.ends_at, occurrence.ends_at + RIDE}
    summary = "Conduire #{French.names(who)} — #{activity.title} (#{LEGS[leg]})"
    event(uid(occurrence, LEGS[leg]), starts, ends, summary, activity.place)
  end

  private def event(uid : String, starts : Time, ends : Time, summary : String, place : String) : Array(String)
    lines = ["BEGIN:VEVENT", "UID:#{uid}", "DTSTAMP:#{stamp(@now)}", "DTSTART:#{stamp(starts)}",
             "DTEND:#{stamp(ends)}", "SUMMARY:#{escape(summary)}"]
    lines << "LOCATION:#{escape(place)}" unless place.empty?
    lines << "END:VEVENT"
  end

  private def uid(occurrence : Agenda::Occurrence, suffix : String? = nil) : String
    base = "activity-#{occurrence.activity.id}-#{occurrence.day.to_s("%Y%m%d")}"
    "#{suffix ? "#{base}-#{suffix}" : base}@quest.yoteau.fr"
  end

  private def stamp(time : Time) : String
    time.to_utc.to_s("%Y%m%dT%H%M%SZ")
  end

  private def escape(text : String) : String
    text.gsub("\\", "\\\\").gsub(";", ";").gsub(",", "\\,").gsub("\n", "\\n")
  end
end
