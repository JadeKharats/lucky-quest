require "../../spec_helper"

describe AccessLinks::Redeem do
  it "signs the member in on this device and uses the link up" do
    token = issue_access_link(child("Lina"))

    response = AppClient.new.exec(AccessLinks::Redeem.with(token))

    response.headers["Location"].should eq(Home::Index.path)
    AccessLinkQuery.new.first.used_at.should_not be_nil
    home = AppClient.new.headers("Cookie": session_cookie(response)).exec(Home::Index)
    home.body.should contain("Salut Lina !")
  end

  it "works only once" do
    token = issue_access_link(child)
    AppClient.new.exec(AccessLinks::Redeem.with(token))

    response = AppClient.new.exec(AccessLinks::Redeem.with(token))

    response.status_code.should eq(404)
    response.body.should contain("Ce lien n&#39;est plus valable")
  end

  it "refuses an expired link" do
    token = issue_access_link(child)
    AccessLinkQuery.new.update(expires_at: 1.minute.ago)

    response = AppClient.new.exec(AccessLinks::Redeem.with(token))

    response.status_code.should eq(404)
    AccessLinkQuery.new.first.used_at.should be_nil
  end

  it "refuses a guest whose access has ended" do
    token = issue_access_link(guest(last_day: Time.local(Household::TIME_ZONE).shift(days: -1)))

    response = AppClient.new.exec(AccessLinks::Redeem.with(token))

    response.status_code.should eq(404)
  end
end
