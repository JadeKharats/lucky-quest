class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    h1 "Connexion"
    render_sign_in_form(@operation)
  end

  private def render_sign_in_form(op)
    form_for SignIns::Create do
      sign_in_fields(op)
      submit "Se connecter", flow_id: "sign-in-button"
    end
  end

  private def sign_in_fields(op)
    mount Shared::Field, attribute: op.email, label_text: "E-mail", &.email_input(autofocus: "true")
    mount Shared::Field, attribute: op.password, label_text: "Mot de passe", &.password_input
  end
end
