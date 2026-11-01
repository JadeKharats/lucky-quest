class AuthenticationFlow < BaseFlow
  private getter email

  def initialize(@email : String)
  end

  def sign_out
    visit Weighings::Index
    sign_out_button.click
  end

  def sign_in(password)
    visit SignIns::New
    fill_form SignInUser,
      email: email,
      password: password
    click "@sign-in-button"
  end

  def should_be_signed_in
    current_page.should have_element("@sign-out-button")
  end

  def should_be_signed_out
    current_page.should have_element("@sign-in-button")
  end

  def should_have_password_error
    current_page.should have_element("body", text: SignInUser::WRONG_CREDENTIALS)
  end

  private def sign_out_button
    el("@sign-out-button")
  end

  # NOTE: this is a shim for readability
  private def current_page
    self
  end
end
