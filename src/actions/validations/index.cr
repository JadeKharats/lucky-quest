class Validations::Index < BrowserAction
  include Auth::RequireQuestValidator

  get "/validations" do
    html IndexPage, completions: CompletionQuery.awaiting_validation.to_a
  end
end
