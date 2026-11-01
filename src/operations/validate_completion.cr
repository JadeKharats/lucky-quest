class ValidateCompletion < Completion::SaveOperation
  needs validator : User

  before_save do
    validated_at.value = Time.utc
    validated_by_id.value = validator.id
  end
end
