require "../../spec_helper"

private def feed_url(member : User) : String
  response = AppClient.new.exec(CalendarFeeds::Create, backdoor_user_id: member.id)
  response.body.match!(%r{/calendrier/[A-Za-z0-9_-]+})[0]
end

describe "Calendar feed" do
  it "serves a member's activities and trips to her calendar app, without a session" do
    lina = child("Lina")
    dad = UserFactory.create &.name("David")
    activity_record("Danse", [lina], driver_to: dad, starts_on: today_in_paris.at_beginning_of_day)
    activity_record("Yoga", [dad], needs_ride: false, starts_on: today_in_paris.at_beginning_of_day)

    lina_feed = AppClient.new.get(feed_url(lina))
    dad_feed = AppClient.new.get(feed_url(dad))

    lina_feed.status_code.should eq(200)
    lina_feed.headers["Content-Type"].should start_with("text/calendar")
    lina_feed.body.should contain("SUMMARY:Danse")
    lina_feed.body.should_not contain("Yoga")
    today = today_in_paris
    starts = Time.local(today.year, today.month, today.day, 14, 0, location: Household::TIME_ZONE)
    lina_feed.body.should contain("DTSTART:#{starts.to_utc.to_s("%Y%m%dT%H%M%SZ")}")
    dad_feed.body.should contain("SUMMARY:Conduire Lina — Danse (aller)")
    dad_feed.body.should contain("SUMMARY:Yoga")
  end

  it "forgets the old link once a new one is made" do
    lina = child
    old = feed_url(lina)
    feed_url(lina)

    AppClient.new.get(old).status_code.should eq(404)
  end

  it "stops serving a guest after her last day" do
    mamie = guest
    url = feed_url(mamie)
    User::SaveOperation.update!(mamie, access_ends_at: 1.minute.ago)

    AppClient.new.get(url).status_code.should eq(404)
  end

  it "answers 404 for an unknown link" do
    AppClient.new.get("/calendrier/unknown").status_code.should eq(404)
  end
end
