require "../spec_helper"

describe "Sessions" do
  it "last a year, so phones and the tablet stay signed in" do
    response = AppClient.new.exec(AccessLinks::Redeem.with(issue_access_link(child)))

    cookie = HTTP::Cookie::Parser.parse_set_cookie(response.headers["Set-Cookie"])
    expires = cookie.try(&.expires) || fail "The session cookie has no expiry"
    expires.should be_close(1.year.from_now, 1.minute)
  end

  it "end for a guest the day after her last day" do
    member = guest
    cookie = session_cookie(AppClient.new.exec(AccessLinks::Redeem.with(issue_access_link(member))))
    User::SaveOperation.update!(member, access_ends_at: 1.minute.ago)

    response = AppClient.new.headers("Cookie": cookie).exec(Home::Index)

    response.headers["Location"].should eq(SignIns::New.path)
  end
end
