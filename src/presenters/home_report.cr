# What the home page shows a member: the family raids of the day, their
# quests of the day and of the week, and how many quests wait for their
# validation.
class HomeReport
  getter agenda : Quests::Agenda?
  getter awaiting_validation : Int32
  getter raids : Array(RaidBoard::View)
  getter names : Hash(Int64, String)
  getter progress : ProgressReport?
  getter upcoming : Array(Agenda::Occurrence)
  getter open_trips : Array(Agenda::Trip)

  def self.for(member : User, now : Time = Time.local(Household::TIME_ZONE)) : self
    agenda = agenda_for(member, now) if member.role.keep_quests?
    awaiting = member.role.validate_quests? ? CompletionQuery.awaiting_validation.select_count.to_i : 0
    progress = ProgressReport.for(member, now) if member.role.keep_quests?
    today = now.at_beginning_of_day
    plan = AgendaBoard.schedule
    upcoming = plan.for_member(member.id, today, today.shift(days: 2))
    trips = member.role.drive? ? plan.open_trips(today, today.shift(days: 7)) : [] of Agenda::Trip
    new(agenda, awaiting, RaidBoard.due(now), UserQuery.new.to_a.to_h { |user| {user.id, user.name} }, progress, upcoming, trips)
  end

  private def self.agenda_for(member : User, now : Time) : Quests::Agenda
    quests = QuestQuery.active.user_id(member.id).to_a
    completions = CompletionQuery.new
      .quest_id.in(quests.map(&.id))
      .period_start.gte(now.at_beginning_of_week)
    Quests::Agenda.new(quests.map(&.to_domain), completions.map(&.to_domain), now)
  end

  def initialize(@agenda : Quests::Agenda?, @awaiting_validation : Int32,
                 @raids : Array(RaidBoard::View), @names : Hash(Int64, String),
                 @progress : ProgressReport?, @upcoming : Array(Agenda::Occurrence),
                 @open_trips : Array(Agenda::Trip))
  end
end
