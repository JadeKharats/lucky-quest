# Stops a weekly activity from today on; past occurrences stay as they were.
class Activities::End < BrowserAction
  include Auth::RequireFamilyManager

  post "/agenda/activites/:activity_id/terminer" do
    activity = ActivityQuery.find(activity_id)
    yesterday = Time.local(Household::TIME_ZONE).at_beginning_of_day.shift(days: -1)
    Activity::SaveOperation.update!(activity, last_day: yesterday)
    flash.success = "Activité « #{activity.title} » terminée."
    redirect Schedules::Index
  end
end
