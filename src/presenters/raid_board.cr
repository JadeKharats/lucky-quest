# Loads raids into the domain: their steps, participants, and the checks of
# the current period.
class RaidBoard
  record View, raid : Quests::Raid, progress : Quests::RaidProgress, period_start : Time

  # The raids due today, for the home page.
  def self.due(now : Time = Time.local(Household::TIME_ZONE)) : Array(View)
    build(RaidQuery.active.to_a.select(&.recurrence.due_on?(now)), now)
  end

  # The raid of a step, if it is active and due today.
  def self.for_step(step : RaidStep, now : Time = Time.local(Household::TIME_ZONE)) : View?
    raid = RaidQuery.active.id(step.raid_id).first?
    return unless raid && raid.recurrence.due_on?(now)
    build([raid], now).first?
  end

  # A raid in its current period, due today or not.
  def self.for_raid(raid : Raid, now : Time = Time.local(Household::TIME_ZONE)) : View
    build([raid], now).first
  end

  def self.domain_raids(raids : Array(Raid)) : Array(Quests::Raid)
    steps = RaidStepQuery.of(raids.map(&.id)).to_a
    participants = RaidStepParticipantQuery.new
      .raid_step_id.in(steps.map(&.id)).id.asc_order.to_a
      .group_by(&.raid_step_id)
    raids.map do |raid|
      own_steps = steps.select { |step| step.raid_id == raid.id }.map do |step|
        ids = (participants[step.id]? || [] of RaidStepParticipant).map(&.user_id)
        Quests::RaidStep.new(id: step.id, title: step.title, participant_ids: ids, rule: step.rule)
      end
      Quests::Raid.new(id: raid.id, title: raid.title, recurrence: raid.recurrence, steps: own_steps)
    end
  end

  private def self.build(raids : Array(Raid), now : Time) : Array(View)
    domain = domain_raids(raids)
    checks = RaidCheckQuery.new
      .raid_step_id.in(domain.flat_map(&.steps.map(&.id)))
      .period_start.gte(now.at_beginning_of_week).to_a
    domain.map do |raid|
      period = raid.recurrence.period_start(now)
      step_ids = raid.steps.map(&.id)
      current = checks.select { |check| check.period_start == period && step_ids.includes?(check.raid_step_id) }
      progress = Quests::RaidProgress.new(raid, current.map { |check| Quests::RaidCheck.new(step_id: check.raid_step_id, member_id: check.user_id) })
      View.new(raid, progress, period)
    end
  end
end
