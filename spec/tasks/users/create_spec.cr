require "../../spec_helper"
require "lucky_task"
require "../../../tasks/users/create"

describe Users::Create do
  it "creates a parent account from the email, the name and the typed password" do
    task, output = build_task(input: "David\nsecret123\nsecret123\n")

    task.run("me@example.com").should be_true

    user = UserQuery.new.email("me@example.com").first
    user.name.should eq("David")
    user.role.should eq(Family::Role::Parent)
    Authentic.correct_password?(user, "secret123").should be_true
    output.to_s.should contain("Created me@example.com")
  end

  it "refuses a confirmation that does not match" do
    task, output = build_task(input: "David\nsecret123\nsomething-else\n")

    task.run("me@example.com").should be_false

    UserQuery.new.select_count.should eq(0)
    output.to_s.should contain("password_confirmation")
  end

  it "refuses an email that already has an account" do
    UserFactory.create &.email("me@example.com")
    task, output = build_task(input: "David\nsecret123\nsecret123\n")

    task.run("me@example.com").should be_false

    UserQuery.new.select_count.should eq(1)
    output.to_s.should contain("email")
  end
end

private def build_task(input : String)
  output = IO::Memory.new
  task = Users::Create.new
  task.input = IO::Memory.new(input)
  task.output = output
  {task, output}
end
