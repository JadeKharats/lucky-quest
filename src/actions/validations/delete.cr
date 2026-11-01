# "Pas encore": the occurrence goes back to à faire.
class Validations::Delete < BrowserAction
  include Auth::RequireQuestValidator

  delete "/validations/:completion_id" do
    completion = CompletionQuery.awaiting_validation.find(completion_id)
    Completion::DeleteOperation.delete!(completion)
    flash.info = "« #{completion.quest.title} » est de nouveau à faire."
    redirect Validations::Index
  end
end
