class Activities::Update < BrowserAction
  include Auth::RequireFamilyManager

  patch "/agenda/activites/:activity_id" do
    SaveActivity.update(ActivityQuery.find(activity_id), params) do |operation, activity|
      if operation.saved?
        flash.success = "Activité « #{activity.title} » mise à jour."
      else
        flash.failure = operation.errors.values.flatten.first? || "Rien n'a changé."
      end
      redirect Schedules::Index
    end
  end
end
