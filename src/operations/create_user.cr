# A parent account with an e-mail and a password, made by `users.create`.
class CreateUser < User::SaveOperation
  param_key :user
  # Change password validations in src/operations/mixins/password_validations.cr
  include PasswordValidations

  permit_columns email, name
  attribute password : String
  attribute password_confirmation : String

  before_save do
    role.value = Family::Role::Parent
    validate_required email, name
    validate_uniqueness_of email
    Authentic.copy_and_encrypt(password, to: encrypted_password) if password.valid?
  end
end
