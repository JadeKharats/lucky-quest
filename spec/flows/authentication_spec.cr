require "../spec_helper"

# Lucky marks its generated LuckyFlow specs as flaky (lucky_cli#883): keep an
# eye on these if they fail intermittently.
describe "Authentication flow", tags: "flow" do
  it "signs an existing account in and out" do
    user = UserFactory.create
    flow = AuthenticationFlow.new(user.email)

    flow.sign_in "wrong-password"
    flow.should_have_password_error
    flow.sign_in "password"
    flow.should_be_signed_in
    flow.sign_out
    flow.should_be_signed_out
  end

  it "sends guests from the home page to the sign-in page" do
    flow = BaseFlow.new

    flow.visit Home::Index

    flow.should have_element("@sign-in-button")
  end

  it "allows sign in through backdoor when testing" do
    user = UserFactory.create
    flow = BaseFlow.new

    flow.visit Me::Show, as: user

    flow.should have_element("@sign-out-button")
  end
end
