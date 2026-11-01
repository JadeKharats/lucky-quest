class Trips::Release < BrowserAction
  include Auth::RequireDriver
  include WeekParam
  include OccurrenceLookup

  post "/agenda/:activity_id/:date/:leg/lacher" do
    occurrence = occurrence_for(activity_id, date)
    chosen = leg_for(leg)
    raise Lucky::RouteNotFoundError.new(context) unless occurrence.drivers.for(chosen) == current_user.id

    ActivityChanges.set_driver(occurrence, chosen, nil)
    flash.info = "C'est noté : quelqu'un d'autre fera l'#{leg}."
    back_to_week(occurrence)
  end
end
