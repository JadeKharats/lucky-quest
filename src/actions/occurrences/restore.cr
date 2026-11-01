class Occurrences::Restore < BrowserAction
  include Auth::RequireFamilyManager
  include WeekParam
  include OccurrenceLookup

  post "/agenda/:activity_id/:date/retablir" do
    occurrence = occurrence_for(activity_id, date)
    ActivityChanges.cancel(occurrence, false)
    flash.success = "#{occurrence.activity.title} du #{French.weekday_date(occurrence.day)} rétablie."
    back_to_week(occurrence)
  end
end
