# Records "C'est fait !" for the current occurrence of a member's quest.
class CompleteQuest < Completion::SaveOperation
  needs member : User
  needs period : Time

  before_save do
    now = Time.utc
    period_start.value = period
    done_at.value = now
    if Quests::Status.after_completion_by(member.role).validated?
      validated_at.value = now
      validated_by_id.value = member.id
    end
  end
end
