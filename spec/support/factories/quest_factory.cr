class QuestFactory < Avram::Factory
  def initialize
    title "Mettre la table"
    frequency Quests::Frequency::Daily
    days_mask 0
  end
end
