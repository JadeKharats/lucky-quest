class RaidFactory < Avram::Factory
  def initialize
    title "Le Sol"
    frequency Quests::Frequency::Daily
    days_mask 0
  end
end

class RaidStepFactory < Avram::Factory
  def initialize
    title "Ranger"
    position 1
    rule Quests::StepRule::Everyone
  end
end
