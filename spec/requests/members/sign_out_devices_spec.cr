require "../../spec_helper"

describe Members::SignOutDevices do
  it "signs every device of the member out" do
    parent = UserFactory.create
    member = child
    signed_in = AppClient.new.exec(AccessLinks::Redeem.with(issue_access_link(member)))
    cookie = session_cookie(signed_in)

    response = AppClient.new.exec(Members::SignOutDevices.with(member.id), backdoor_user_id: parent.id)

    response.status_code.should eq(302)
    later = AppClient.new.headers("Cookie": cookie).exec(Home::Index)
    later.headers["Location"].should eq(SignIns::New.path)
  end

  it "does not exist for a child" do
    member = child

    response = AppClient.new.exec(Members::SignOutDevices.with(member.id), backdoor_user_id: member.id)

    response.status_code.should eq(404)
    member.reload.session_generation.should eq(0)
  end
end
