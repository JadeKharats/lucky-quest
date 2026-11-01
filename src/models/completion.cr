# "C'est fait !" for one occurrence of a quest, validated or not yet.
class Completion < BaseModel
  table do
    belongs_to quest : Quest
    column period_start : Time
    column done_at : Time
    column validated_at : Time?
    belongs_to validated_by : User?
  end

  def to_domain : Quests::Completion
    Quests::Completion.new(quest_id: quest_id, period_start: period_start, validated: !validated_at.nil?)
  end
end
