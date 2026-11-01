class Occurrences::Cancel < BrowserAction
  include Auth::RequireFamilyManager
  include WeekParam
  include OccurrenceLookup

  post "/agenda/:activity_id/:date/annuler" do
    occurrence = occurrence_for(activity_id, date)
    ActivityChanges.cancel(occurrence, true)
    flash.info = "#{occurrence.activity.title} du #{French.weekday_date(occurrence.day)} annulée."
    back_to_week(occurrence)
  end
end
