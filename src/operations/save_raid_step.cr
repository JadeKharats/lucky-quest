# A raid step and who takes part in it: parents and children, never guests.
class SaveRaidStep < RaidStep::SaveOperation
  param_key :raid_step

  permit_columns title, rule
  attribute participant_ids : Array(Int64)

  before_save do
    validate_required title, message: "Donnez un titre à l'étape."
    validate_required rule, message: "Choisissez une règle."
    check_participants
  end

  after_save replace_participants

  def self.form_for(step : RaidStep) : self
    ids = RaidStepParticipantQuery.new.raid_step_id(step.id).id.asc_order.map(&.user_id)
    new(step, participant_ids: ids)
  end

  private def chosen_ids : Array(Int64)
    participant_ids.value || [] of Int64
  end

  private def check_participants
    members = UserQuery.new.id.in(chosen_ids).to_a
    if chosen_ids.empty? || members.size != chosen_ids.uniq.size || !members.all?(&.role.keep_quests?)
      participant_ids.add_error "Choisissez au moins un participant parmi les parents et les enfants."
    end
  end

  private def replace_participants(step : RaidStep)
    RaidStepParticipantQuery.new.raid_step_id(step.id).delete
    chosen_ids.uniq.each do |user_id|
      RaidStepParticipant::SaveOperation.create!(raid_step_id: step.id, user_id: user_id)
    end
  end
end
