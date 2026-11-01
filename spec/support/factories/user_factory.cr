class UserFactory < Avram::Factory
  def initialize
    name "Membre"
    role Family::Role::Parent
    email "#{sequence("test-email")}@example.com"
    encrypted_password Authentic.generate_encrypted_password("password")
  end

  # A daughter or a grandparent: no e-mail, no password, she comes in with an
  # access link.
  def without_password
    email nil
    encrypted_password nil
  end
end
