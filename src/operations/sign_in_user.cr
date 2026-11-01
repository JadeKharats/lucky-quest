class SignInUser < Avram::Operation
  param_key :user
  # You can modify this in src/operations/mixins/user_from_email.cr
  include UserFromEmail

  WRONG_CREDENTIALS = "E-mail ou mot de passe incorrect."

  attribute email : String
  attribute password : String

  # Run validations and yields the operation and the user if valid
  def run
    user = user_from_email
    validate_credentials(user)

    if valid?
      user
    end
  end

  # `validate_credentials` determines if a user can sign in.
  #
  # If desired, you can add additional checks in this method, e.g.
  #
  #    if user.locked?
  #      email.add_error "is locked out"
  #    end
  private def validate_credentials(user)
    if user
      unless Authentic.correct_password?(user, password.value.to_s)
        password.add_error WRONG_CREDENTIALS
      end
    else
      # Same message as a wrong password: a private family app does not
      # tell strangers which emails have an account.
      password.add_error WRONG_CREDENTIALS
    end
  end
end
