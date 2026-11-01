module Quests
  enum StepState
    Locked
    Open
    Done
  end

  # Where a raid stands in its current period: each step is locked until the
  # previous one is done.
  class RaidProgress
    @states : Hash(Int64, StepState)

    def initialize(@raid : Raid, @checks : Array(RaidCheck))
      @states = compute_states
    end

    def state(step : RaidStep) : StepState
      @states[step.id]
    end

    def finished? : Bool
      !@raid.steps.empty? && @raid.steps.all? { |step| state(step).done? }
    end

    # Participants who checked, in the order of the participants list.
    def checked_by(step : RaidStep) : Array(Int64)
      step.participant_ids.select { |member| checked?(step, member) }
    end

    # Participants the step is still waiting for.
    def awaited(step : RaidStep) : Array(Int64)
      return [] of Int64 if state(step).done?
      step.participant_ids.reject { |member| checked?(step, member) }
    end

    def can_check?(member_id : Int64, step : RaidStep) : Bool
      state(step).open? && step.participant_ids.includes?(member_id) && !checked?(step, member_id)
    end

    # Her own check, as long as nobody has started the next step.
    def can_undo?(member_id : Int64, step : RaidStep) : Bool
      return false unless checked?(step, member_id)
      after = next_step(step)
      after.nil? || !started?(after)
    end

    def steps_from(step : RaidStep) : Array(RaidStep)
      @raid.steps.skip_while { |other| other.id != step.id }
    end

    private def compute_states : Hash(Int64, StepState)
      previous_done = true
      @raid.steps.to_h do |step|
        state = if !previous_done
                  StepState::Locked
                elsif done?(step)
                  StepState::Done
                else
                  StepState::Open
                end
        previous_done = state.done?
        {step.id, state}
      end
    end

    private def done?(step : RaidStep) : Bool
      return false if step.participant_ids.empty?
      if step.rule.anyone?
        started?(step)
      else
        step.participant_ids.all? { |member| checked?(step, member) }
      end
    end

    private def started?(step : RaidStep) : Bool
      @checks.any? { |check| check.step_id == step.id }
    end

    private def checked?(step : RaidStep, member_id : Int64) : Bool
      @checks.any? { |check| check.step_id == step.id && check.member_id == member_id }
    end

    private def next_step(step : RaidStep) : RaidStep?
      index = @raid.steps.index { |other| other.id == step.id }
      index.try { |position| @raid.steps[position + 1]? }
    end
  end
end
