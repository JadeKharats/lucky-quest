# A parent chooses who drives one trip of one occurrence (or nobody).
class Trips::Assign < BrowserAction
  include Auth::RequireFamilyManager
  include WeekParam
  include OccurrenceLookup

  post "/agenda/:activity_id/:date/:leg/conducteur" do
    occurrence = occurrence_for(activity_id, date)
    chosen = leg_for(leg)
    raw = params.nested?("trip")["driver_id"]?.to_s
    driver = raw.empty? ? nil : UserQuery.new.id(raw.to_i64? || 0_i64).first?
    raise Lucky::RouteNotFoundError.new(context) if !raw.empty? && !driver.try(&.role.drive?)

    ActivityChanges.set_driver(occurrence, chosen, driver.try(&.id))
    flash.success = "Conducteur mis à jour."
    back_to_week(occurrence)
  end
end
