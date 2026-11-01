class Activities::Create < BrowserAction
  include Auth::RequireFamilyManager

  post "/agenda/activites" do
    SaveActivity.create(params) do |operation, activity|
      if activity
        flash.success = "Activité « #{activity.title} » ajoutée."
      else
        flash.failure = operation.errors.values.flatten.first? || "Activité non ajoutée."
      end
      redirect Schedules::Index
    end
  end
end
