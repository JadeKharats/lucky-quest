# Quest has no public sign-up: accounts are created from the command line.
#
#   lucky users.create me@example.com
class Users::Create < LuckyTask::Task
  summary "Create a parent account (Quest has no public sign-up)"
  name "users.create"
  positional_arg :email, "Email of the new account", example: "me@example.com"

  property input : IO = STDIN

  def call
    exit(1) unless run(email)
  end

  # Returns whether the account was created; `call` turns it into the exit status.
  def run(email : String) : Bool
    member_name = ask_line("Name: ")
    password = ask_password("Password: ")
    confirmation = ask_password("Confirm password: ")

    CreateUser.create(email: email, name: member_name, password: password, password_confirmation: confirmation) do |operation, user|
      if user
        output.puts "Created #{user.email}"
      else
        output.puts "Not created:"
        operation.errors.each do |field, messages|
          output.puts "  #{field}: #{messages.join(", ")}"
        end
      end
      !user.nil?
    end
  end

  private def ask_line(prompt : String) : String
    output.print prompt
    input.gets.to_s.chomp
  end

  private def ask_password(prompt : String) : String
    output.print prompt
    typed = read_hidden_line
    output.puts
    typed.to_s.chomp
  end

  private def read_hidden_line : String?
    terminal = input
    if terminal.is_a?(IO::FileDescriptor) && terminal.tty?
      terminal.noecho(&.gets)
    else
      input.gets
    end
  end
end
