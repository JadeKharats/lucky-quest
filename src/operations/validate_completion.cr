class ValidateCompletion < Completion::SaveOperation
  needs validator : User

  after_save award_xp

  before_save do
    validated_at.value = Time.utc
    validated_by_id.value = validator.id
  end

  private def award_xp(completion : Completion)
    XpLedger.award(completion)
  end
end
