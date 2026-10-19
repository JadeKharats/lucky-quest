require "../../spec_helper"
require "lucky_task"
require "../../../tasks/users/create"

describe Users::Create do
  it "creates the account from the email and the typed password" do
    task, output = build_task(input: "secret123\nsecret123\n")

    task.run("me@example.com").should be_true

    user = UserQuery.new.email("me@example.com").first
    Authentic.correct_password?(user, "secret123").should be_true
    output.to_s.should contain("Created me@example.com")
  end

  it "refuses a confirmation that does not match" do
    task, output = build_task(input: "secret123\nsomething-else\n")

    task.run("me@example.com").should be_false

    UserQuery.new.select_count.should eq(0)
    output.to_s.should contain("password_confirmation")
  end

  it "refuses an email that already has an account" do
    UserFactory.create &.email("me@example.com")
    task, output = build_task(input: "secret123\nsecret123\n")

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
