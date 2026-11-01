class Trips::Take < BrowserAction
  include Auth::RequireDriver
  include WeekParam
  include OccurrenceLookup

  post "/agenda/:activity_id/:date/:leg/prendre" do
    occurrence = occurrence_for(activity_id, date)
    chosen = leg_for(leg)
    trip = occurrence.trips.find { |candidate| candidate.leg == chosen }
    raise Lucky::RouteNotFoundError.new(context) if occurrence.cancelled || trip.nil? || trip.driver_id

    ActivityChanges.set_driver(occurrence, chosen, current_user.id)
    flash.success = "Merci ! Tu fais l'#{leg} : #{occurrence.activity.title}, #{French.weekday_date(occurrence.day)}."
    back_to_week(occurrence)
  end
end
