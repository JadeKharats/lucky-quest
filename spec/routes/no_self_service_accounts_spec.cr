require "../spec_helper"

# Quest is a private family tool: accounts come from `lucky users.create`,
# there is no email to reset a password with, and the browser session is the
# only way in (no token API).
describe "Account routes" do
  {
    {"GET", "/sign_up"},
    {"POST", "/sign_up"},
    {"POST", "/api/sign_ups"},
    {"POST", "/api/sign_ins"},
    {"GET", "/api/me"},
    {"GET", "/password_reset_requests/new"},
    {"POST", "/password_reset_requests"},
    {"GET", "/password_resets/1/edit"},
    {"POST", "/password_resets/1"},
  }.each do |method, path|
    it "has no #{method} #{path}" do
      Lucky.router.find_action(method, path).should be_nil
    end
  end

  it "still signs in" do
    Lucky.router.find_action("GET", "/sign_in").should_not be_nil
  end
end
