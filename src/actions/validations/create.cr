class Validations::Create < BrowserAction
  include Auth::RequireQuestValidator

  post "/validations/:completion_id" do
    completion = CompletionQuery.awaiting_validation.find(completion_id)
    ValidateCompletion.update!(completion, validator: current_user)
    flash.success = "« #{completion.quest.title} » validée pour #{completion.quest.user.name}."
    redirect Validations::Index
  end
end
