# Read by calendar apps, without a session: the token is the key.
class CalendarFeeds::Show < BrowserAction
  include Auth::AllowGuests
  disable_cookies

  PAST  = 14
  AHEAD = 56

  get "/calendrier/:token" do
    member = UserQuery.new.calendar_token_digest(AccessLink.digest(token)).first?
    now = Time.utc
    raise Lucky::RouteNotFoundError.new(context) unless member && member.access_window.open?(now)

    today = Time.local(Household::TIME_ZONE).at_beginning_of_day
    occurrences = AgendaBoard.schedule.between(today.shift(days: -PAST), today.shift(days: AHEAD))
    feed = IcalFeed.new(occurrences, member_id: member.id, member_name: member.name, names: AgendaBoard.names, now: now)
    plain_text feed.to_s, content_type: "text/calendar; charset=utf-8"
  end
end
